module Api::V1
  class ApiController < ApplicationController
    include ConnecConcern
    require 'date'
    require 'active_support'
    
    before_filter :authenticate, :checkParameters
    
    rescue_from ConnecConcern::ConnecAccessException do |exception|
      render json: exception.message, status: exception.code
    end

    protected
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        @username = username
        @password = password
      end
    end

    def getHistParameters
      histParameters = params[:hist_parameters]
      if(histParameters.nil?)
        # if no histParameters is given we return a Year to Date histParameters
        from = Date.today.beginning_of_year
        to = Date.today
        HistParameters.new(from, to, HistParameters::MONTHLY)
      else
        parsed = JSON.parse(histParameters)
        HistParameters.fromHttpParameters(parsed)
      end
    end

    def getAuth(groupId)
      ConnecAuthentication.new(groupId, @username, @password)
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