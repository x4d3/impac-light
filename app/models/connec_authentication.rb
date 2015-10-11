# this class contains all the necessited information to communicate with Connect API
class ConnecAuthentication
    def initialize(groupId, username, password)
        @groupId = groupId
        @username = username
        @password = password
    end
    attr_reader :groupId, :username, :password
    # returns an HTTP authentication Hash
    def getHttpAuthentication
        {:username => @username, :password => @password}
    end
end
