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
    def index
      organization_ids = params[:organization_ids]
      accounts = getAccounts(getAuth())
      filteredAccount = accounts.select do |account|
        account['class'] == 'ASSET' &&  organization_ids.include?(account['channel_id'])
      end
      summary =  filteredAccount.map do |account|
        {:label => account['name'], :total => account['current_balance']}
      end
      render json: {:organizations => organization_ids, :currency => "EUR", :summary => summary}
    end
  end
end
