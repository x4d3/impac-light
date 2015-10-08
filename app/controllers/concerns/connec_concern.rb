require 'httparty'

module ConnecConcern
    END_POINT = ENV["CONNEC_ENDPOINT"]

    def getAccounts(groupId, username, password)
        auth = {:username => username, :password => password}
        url = createUrl(groupId, 'organizations')
        puts END_POINT
        puts url
        response = HTTParty.get(url, :basic_auth => auth, :verify => false )
        puts response.body, response.code, response.message, response.headers.inspect
    end
    def createUrl(groupId, suffix)
        return "#{END_POINT}/#{groupId}/#{suffix}"
    end
end

