require 'httparty'
require 'yaml'

# utils method used to communicate with the connec API
# if ENV["CONNEC_OFFLINE_MODE"] is true, answers will be generated using the 
# mock_http_responses.yaml file
module ConnecConcern
  # this is the connec url endpoint, for example: https://api-connec.maestrano.com/api/v2
  END_POINT = ENVied.CONNEC_ENDPOINT
  def getOrganizations(connectAuth)
    response = getResponse(connectAuth, 'organizations', {:$top => 10})
    puts response.code, response.body, response.message
  end  
  
  private
  # class used to emulate the HTTPResponse in offline mode
  class MockHTTPResponse
    def initialize(code, body, message)
        @code = code
        @body = body
        @message = message
    end
    attr_reader :body, :code, :message
  end
  def getResponse(connectAuth, suffix, query)
    if ENVied.CONNEC_OFFLINE_MODE
      # the application is in offline mode (for development and test)
      # TODO: find an easier way to reference the mock_http_responses file.
      responsesPath = File.join(Rails.root, 'app', 'controllers', 'concerns', 'mock_http_responses.yaml')
      File.open(responsesPath) do |file|
        messages = YAML.load(file)
        message = messages[suffix]
        MockHTTPResponse.new(200, message, 'body')
      end
    else
      auth = connectAuth.getHttpAuthentication
      url = "#{END_POINT}/#{connectAuth.groupId}/#{suffix}"
      # FIXME: make sure the ruby installation contains the proper SSH certificate to communicate
      # with the connec end point in order to remove the :verify => false
      input =  {:basic_auth => auth, :verify => false , :query => query}
      HTTParty.get(url, input)
    end
  end
end