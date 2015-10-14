# this class contains all the necessited information to communicate with Connect API
class ConnecAuthentication
    def initialize(group_id, username, password)
        @group_id = group_id
        @username = username
        @password = password
    end
    attr_reader :group_id, :username, :password
    # returns an HTTP authentication Hash
    def get_http_authentication
        {:username => @username, :password => @password}
    end
end
