module Api::V1::Accounts
  class AssetsSummaryController < ApiController
    def index
      params.require(:organization_ids)
      organization_ids = params[:organization_ids]
      for organization_id in organization_ids
         logger.tagged("AssetsSummaryController") { logger.debug organization_id }   
      end
      result = {}
      result['username'] = @username;
      result['organization_ids'] = organization_ids;
      render json: result
    end

  end
end
