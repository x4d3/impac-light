module Api::V1::Accounts
  # Returns the sums of the accounts of category EXPENSE and the sum of those of category REVENUE throughout a given period of time.
  # Example:
  # {
  #     "organizations": ["org-abcd","org-qwer"],
  #     "values": {
  #         "expenses": [42587.32, 41587.54, 40558.45],
  #         "revenue": [55871.33, 54887.66, 53669.24]
  #     }
  #     "currency": "EUR",
  #     "dates": ["2015-01-01", "2015-02-01", "2015-02-14"],
  #     "hist_parameters": {
  #         "from": "2015-01-01",
  #         "to": "2015-02-14",
  #         "period": "MONTHLY"
  #     }
  # }
  class ExpensesRevenueController < Api::V1::ApiController
    def index
      organization_ids = params[:organization_ids]
      hist_parameters = get_hist_parameters
      expenses = []
      revenue = []
      dates = []
      organization_ids.each_with_index  do |organization_id, i|
        connec_auth = get_auth(organization_id)
        connec_result = get_income_statement(connec_auth, hist_parameters)
        income_statements = connec_result['income_statements']
        #The income_statements contains an extra YTD value at the end that needs to be removed
        income_statements = income_statements[0...-1]
        income_statements.each_with_index do |income_statement, j|
          if (i == 0)
            dates[j] = income_statement['from']
            expenses[j] = 0
            revenue[j] = 0
          end
          expenses[j] += income_statement['total_operating_expenses']
          revenue[j] += income_statement['total_revenue']
        end
      end
      result = {}
      result[:organizations] = organization_ids
      result[:values] = {:expenses => expenses, :revenue => revenue}
      result[:dates] = dates
      result[:hist_parameters] = hist_parameters.to_http_query
      result[:organizations] = organization_ids
      render json: result
    end
  end
end
