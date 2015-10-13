module Api::V1::Accounts
  # Returns an array of all your accounts of the category “Assets” values.
  #  {
  #    "organizations": ["org-abcd","org-qwer"],
  #    "currency": "EUR",
  #    "summary": [
  #        {"label": "Asset Account 1", "total": 12547.23},
  #        {"label": "Asset Account 2", "total": 6057.87},
  #        {"label": "Asset Account 3", "total": 8954.45}
  #    ]
  # }
  class AssetsSummaryController < ApiController
    #for date manipulation
    require 'date'
    require 'active_support'
    def index
      organization_ids = params[:organization_ids]
      accountsSummary = []
      startDayOfMonth = Date.today.beginning_of_month
      # get last day of month: >>1 shift one month, - 1 remove one day
      lastDayOfMonth = (startDayOfMonth >> 1) - 1
      # getAccountsSummary for this current month
      histparameters =  HistParameters.new(startDayOfMonth, lastDayOfMonth, HistParameters::MONTHLY)
      for organization_id in organization_ids
        connecAuth = getAuth(organization_id)
        result = getAccountsSummary(connecAuth, histparameters)
        accountsSummary.concat(result['accounts'])
      end
      #only take AssetClass account
      filteredAccount = accountsSummary.select do |account|
        account['classification'] == 'ASSET'
      end
      # TODO: manage multi currency
      currency = nil
      summary =  filteredAccount.map do |account|
        currency = account['currency']
        #we need to take the only value in the balances array
        {:label => account['name'], :total => account['balances'][0]['to_balance']}
      end
      render json: {:organizations => organization_ids, :currency => currency, :summary => summary}
    end
  end
end
