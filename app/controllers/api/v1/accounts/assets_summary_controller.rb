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
  class AssetsSummaryController < Api::V1::ApiController
    #for date manipulation
    require 'date'
    require 'active_support'
    def index
      organization_ids = params[:organization_ids]
      accounts_summary = []
      # get_accounts_summary for this current month
      hist_parameters =  HistParameters.new(Date.today.beginning_of_month, Date.today, HistParameters::MONTHLY)
      for organization_id in organization_ids
        connec_auth = get_auth(organization_id)
        result = get_accounts_summary(connec_auth, hist_parameters)
        accounts_summary.concat(result['accounts'])
      end
      #only take AssetClass account
      filtered_account = accounts_summary.select do |account|
        account['classification'] == 'ASSET'
      end
      # TODO: manage multi currency
      currency = nil
      summary =  filtered_account.map do |account|
        currency = account['currency']
        #we need to take the only value in the balances array
        {:label => account['name'], :total => account['balances'][0]['to_balance']}
      end
      render json: {:organizations => organization_ids,:currency => currency,:summary => summary}
    end
  end
end
