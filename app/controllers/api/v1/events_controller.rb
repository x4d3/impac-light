module Api::V1
  class EventsController < ApiController
    def index
      render json: params.to_json
    end
  end
end