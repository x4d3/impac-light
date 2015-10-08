require 'test_helper'

class MockConnecConcernImpl
    include ConnecConcern
end

class ConnecConcernTest < ActiveSupport::TestCase
    test "getAccounts" do
        assert true
        connect = MockConnecConcernImpl.new()
        connect.getAccounts(ENV['GROUP_ID'], ENV['API_KEY'], ENV['API_SECRET'])
    end
end
