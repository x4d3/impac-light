module Api::V1::Accounts::AccountingValues
  # Returns the EBITDA (Revenue - Expenses excluding Interest, Taxes, Depreciation and Amortization) throughout a given period of time.
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
  class EbitdaController < ApiController
    EBITDA_LEGEND = 'Revenue - Expenses (excluding Taxes, Interests, Depreciation and Amortization)'
    def index
      organization_ids = params['organization_ids']
      accounts = getAccounts(getAuth())
      filteredAccount = accounts.select do |account|
        # EBITDA only contains REVENUE and EXPENSE
        account[:class] == 'REVENUE' &&  account[:type] == 'EXPENSE' &&  organization_ids.include?(account['channel_id']
      end
      groupedValues = sumAndGroupByDate(filteredAccount, 'created_at', 'current_balance')
      accounting = {}
      accounting[:currency ] = 'EUR'
      accounting[:dates ] = groupedValues.dates
      accounting[:legend ] = EBITDA_LEGEND
      accounting[:type ] = 'EBITDA'
      accounting[:values ] = groupedValues.values
      result = {:organizations => organization_ids, :accounting => accounting}
      
      render json: 
    end
  end
end
