require 'httparty'

# utils method used to communicate with the connec API
# if ENV["CONNEC_OFFLINE_MODE"] is true, answers will be generated using the files in the mock folder
module ConnecConcern
  # Exception raised when Connec Api access fails
  class ConnecAccessException < StandardError
   attr_reader :code
    def initialize(code)
      @code = code
    end
  end
  # this is the connec url endpoint, for example: https://api-connec.maestrano.com/api
  END_POINT = ENVied.CONNEC_ENDPOINT
  
  # retrieve the accounts using the v2 end point
  def get_accounts(connec_auth)
    getV2Data(connec_auth, 'accounts')
  end  
  
  def get_balance_sheets(connec_auth, hist_parameters = nil)
    get_report_data(connec_auth, 'balance_sheet', hist_parameters)
  end
  
  def get_accounts_summary(connec_auth, hist_parameters = nil)
    get_report_data(connec_auth, 'accounts_summary', hist_parameters)
  end
  
  def get_income_statement(connec_auth, hist_parameters = nil)
    get_report_data(connec_auth, 'income_statement', hist_parameters)
  end
  
  private
  # Read the data using the V2 API, this manage pagination
  def getV2Data(connec_auth, suffix)
    if ENVied.CONNEC_OFFLINE_MODE
      return read_mock_data(suffix)
    end
    url = "#{END_POINT}/v2/#{connec_auth.group_id}/#{suffix}"
    result = []
    # manage pagination
    skip = 0
    begin
      query = {:$skip => skip}
      response = get_http_response(connec_auth, url, query)
      parsed_response = JSON.parse response.body
      result.concat(parsed_response[suffix])
      pagination = parsed_response['pagination']
      skip += pagination['top']
    end until result.length == pagination['total']
    result
  end
  
  # hist_parameters is optional
  def get_report_data(connec_auth, suffix, hist_parameters)
    if ENVied.CONNEC_OFFLINE_MODE
      return read_mock_data(suffix)
    end
    url = "#{END_POINT}/reports/#{connec_auth.group_id}/#{suffix}"
    query = hist_parameters.nil? ? {} : hist_parameters.to_http_query
    response = get_http_response(connec_auth, url, query)
    JSON.parse response.body
  end
  # read json data directly from files when the application is in offline mode (for development and test)
  def read_mock_data(suffix)  
      # TODO: find an easier way to reference the mock file.
      responsesPath = File.join(Rails.root, 'app', 'controllers', 'concerns', 'mock', suffix)
      File.open(responsesPath) do |file|
        JSON.parse file.read
      end
  end
  
  def get_http_response(connec_auth, url, query)
    auth = connec_auth.get_http_authentication
    # FIXME: make sure the ruby installation contains the proper SSH certificate to communicate
    # with the connec end point in order to remove the :verify => false
    input = {:basic_auth => auth, :verify => false, :query => query}
    response = HTTParty.get(url, input)
    if response.code != 200
      raise ConnecAccessException.new(response.code), "could not connect to Connec API: #{response.body}"
    end
    response
  end
end
