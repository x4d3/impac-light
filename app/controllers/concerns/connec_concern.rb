require 'httparty'

# utils method used to communicate with the connec API
# if ENV["CONNEC_OFFLINE_MODE"] is true, answers will be generated using the 
# mock_http_responses.yaml file
module ConnecConcern
  
  # this is the connec url endpoint, for example: https://api-connec.maestrano.com/api
  END_POINT = ENVied.CONNEC_ENDPOINT
  
  # retrieve the accounts using the v2 end point
  def getAccounts(connecAuth)
    getV2Data(connecAuth, 'accounts')
  end  
  
  def getBalanceSheets(connecAuth, histParameters = nil)
    getReportData(connecAuth, 'balance_sheet', histParameters)
  end
  
  def getAccountsSummary(connecAuth, histParameters = nil)
    getReportData(connecAuth, 'accounts_summary', histParameters)
  end
  
  def getIncomeStatement(connecAuth, histParameters = nil)
    getReportData(connecAuth, 'income_statement', histParameters)
  end
  
  private
  # Read the data using the V2 API, this manage pagination
  def getV2Data(connecAuth, suffix)
    if ENVied.CONNEC_OFFLINE_MODE
      return readMockData(suffix)
    end
    url = "#{END_POINT}/v2/#{connecAuth.groupId}/#{suffix}"
    result = []
    # manage pagination
    skip = 0
    begin
      # FIXME: make sure the ruby installation contains the proper SSH certificate to communicate
      # with the connec end point in order to remove the :verify => false
      query = {:$skip => skip}
      response = getHTTPResponse(connecAuth, url, query)
      parsedResponse = JSON.parse response.body
      result.concat(parsedResponse[suffix])
      pagination = parsedResponse['pagination']
      skip += pagination['top']
    end until result.length == pagination['total']
    result
  end
  
  # histParameters is optional
  def getReportData(connecAuth, suffix, histParameters)
    if ENVied.CONNEC_OFFLINE_MODE
      return readMockData(suffix)
    end
    url = "#{END_POINT}/reports/#{connecAuth.groupId}/#{suffix}"
    query = histParameters.nil? ? {} : histParameters.toHttpQuery
    response = getHTTPResponse(connecAuth, url, query)
    if response.code != 200
      raise  "could not connect to Connec API: #{response.code}, #{response.body}"
    end
    JSON.parse response.body
  end
  # read json data directly from files when the application is in offline mode (for development and test)
  def readMockData(suffix)  
      # TODO: find an easier way to reference the mock file.
      responsesPath = File.join(Rails.root, 'app', 'controllers', 'concerns', 'mock', suffix)
      File.open(responsesPath) do |file|
        JSON.parse file.read
      end
  end
  
  def getHTTPResponse(connecAuth, url, query)
    auth = connecAuth.getHttpAuthentication
    # FIXME: make sure the ruby installation contains the proper SSH certificate to communicate
    # with the connec end point in order to remove the :verify => false
    input = {:basic_auth => auth, :verify => false, :query => query}
    response = HTTParty.get(url, input)
    if response.code != 200
      raise "could not connect to Connec API: #{response.code}"
    end
    response
  end
end