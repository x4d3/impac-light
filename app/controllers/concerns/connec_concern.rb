require 'httparty'
require 'yaml'

# utils method used to communicate with the connec API
# if ENV["CONNEC_OFFLINE_MODE"] is true, answers will be generated using the 
# mock_http_responses.yaml file
module ConnecConcern
  # this is the connec url endpoint, for example: https://api-connec.maestrano.com/api/v2
  END_POINT = ENVied.CONNEC_ENDPOINT
  def getAccounts(connectAuth)
    getList(connectAuth, 'accounts')
  end  
  private
  def getList(connectAuth, suffix)
    if ENVied.CONNEC_OFFLINE_MODE
      # the application is in offline mode (for development and test)
      # TODO: find an easier way to reference the mock_http_responses file.
      responsesPath = File.join(Rails.root, 'app', 'controllers', 'concerns', 'mock_http_responses.yaml')
      File.open(responsesPath) do |file|
        JSON.parse YAML.load(file)[suffix]
      end
    else
      auth = connectAuth.getHttpAuthentication
      url = "#{END_POINT}/#{connectAuth.groupId}/#{suffix}"
      result = []
      #manage pagination
      skip = 0
      begin
        # FIXME: make sure the ruby installation contains the proper SSH certificate to communicate
        # with the connec end point in order to remove the :verify => false
        query = {:$skip => skip}
        input =  {:basic_auth => auth, :verify => false , :query => query}
        response = HTTParty.get(url, input)
        if response.code != 200
          raise "could not connect to Connec API: #{response.code}"
        end
        parsedResponse = JSON.parse response.body
        result.concat(parsedResponse[suffix])
        pagination = parsedResponse['pagination']
        skip += pagination['top']
      end until result.length == pagination['total']
      result
    end
  end
end