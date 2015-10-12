module Api::V1
  class ApiController < ApplicationController
    include ConnecConcern
    before_filter :authenticate, :checkParameters
    protected
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        @username = username
        @password = password
      end
    end
    def checkParameters
      params.require(:organization_ids)
      organization_ids = params[:organization_ids]
      if (!organization_ids.kind_of?(Array))
        raise InvalidParameterError.new('organization_ids should be an array')
      end
    end
  end
  class InvalidParameterError < StandardError
  end
end