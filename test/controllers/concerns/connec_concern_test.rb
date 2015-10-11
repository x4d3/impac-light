require 'test_helper'

class ConnecConcernTest < ActiveSupport::TestCase
    #simple mock object used to test the ConnecConcern module
    connecConcernObj = Object.new
    connecConcernObj.extend(ConnecConcern)
    auth = ConnecAuthentication.new(ENVied.GROUP_ID, ENVied.API_KEY, ENVied.API_SECRET)
    
    test "getOrganizations" do
        connecConcernObj.getOrganizations(auth)
    end
end
