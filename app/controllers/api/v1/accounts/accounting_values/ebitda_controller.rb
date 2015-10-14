module Api::V1::Accounts::AccountingValues
  # Returns the EBITDA (Revenue - Expenses excluding Interest, Taxes, Depreciation and Amortization) throughout a given period of time.
  # 
  # EBITDA = (REVENUE - COSTOFGOODSSOLD - EXPENSE)[where subtype not in EXCLUDED_SUBTYPES] 
  #
  # Example:
  # {
  #     "organizations": ["org-abcd","org-qwer"],
  #     "accounting": {
  #         "currency": "EUR",
  #         "dates": ["2015-01-01", "2015-02-01", "2015-02-14"],
  #         "legend": "Revenue - Expenses (excluding Taxes, Interests, Depreciation and Amortization)",
  #         "type": 'EBITDA',
  #         "values": [1254.50,1245.30,1124.15]
  #     },
  #     "hist_parameters": {
  #         "from": "2015-01-01",
  #         "to": "2015-02-14",
  #         "period": "MONTHLY"
  #     }
  # }
  class EbitdaController < Api::V1::ApiController
    EBITDA_LEGEND = 'Revenue - Expenses (excluding Taxes, Interests, Depreciation and Amortization)'
    #Subtype excluded for EBITDA computation
    EXCLUDED_SUB_TYPES = ['GLOBALTAXEXPENSE', 'TAXESPAID', 'DEPRECIATION', 'INTERESTPAID', 'AMORTIZATION']
    def index
      organization_ids = params[:organization_ids]
      hist_parameters = get_hist_parameters
      dates = []
      values = []
      organization_ids.each_with_index  do |organization_id, i|
        connec_auth = get_auth(organization_id)
        connecResult = get_income_statement(connec_auth, hist_parameters)
        income_statements = connecResult['income_statements']
        #The income_statements contains an extra YTD value at the end that needs to be removed
        income_statements = income_statements[0...-1]
        income_statements.each_with_index do |income_statement, j|
          if (i == 0)
            dates[j] = income_statement['from']
            values[j] = 0
          end
          revenue = filterAndSumTotal(income_statement['revenue'])
          cogs = filterAndSumTotal(income_statement['cogs'])
          expenses = filterAndSumTotal(income_statement['operating_expenses'])
          values[j] += revenue - cogs - expenses
        end
      end
      accounting = {}
      #FIXME: retrieve currency properly 
      accounting[:currency ] = 'EUR'
      accounting[:dates ] = dates
      accounting[:legend ] = EBITDA_LEGEND
      accounting[:type ] = 'EBITDA'
      accounting[:values ] = values
      render json: {:organizations => organization_ids, :accounting => accounting, :hist_parameters => hist_parameters.to_http_query}
    end
    
    private
    def filterAndSumTotal(array)
      array.reject {|x| EXCLUDED_SUB_TYPES.include?(x["sub_type"])}.map {|x| x['total']}.inject(:+)
    end
  end
end
