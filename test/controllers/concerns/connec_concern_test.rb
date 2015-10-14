require 'test_helper'

class ConnecConcernTest < ActiveSupport::TestCase
    #simple mock object used to test the ConnecConcern module
    mock_concern = Object.new
    mock_concern.extend(ConnecConcern)
    auth = ConnecAuthentication.new(ENVied.GROUP_ID, ENVied.API_KEY, ENVied.API_SECRET)
    test "get_accounts" do
        accounts = mock_concern.get_accounts(auth)
        assert accounts.length > 0
    end
    test "get_balance_sheets" do
        result = mock_concern.get_balance_sheets(auth)
        assert result['balance_sheets'].length > 0
    end
    test "get_accounts_summary" do
        result = mock_concern.get_accounts_summary(auth)
        assert result['accounts'].length > 0
    end
    test "get_income_statement" do
        hist_parameters = HistParameters.new(DateTime.new(2014,1,1), DateTime.new(2015,1,1), HistParameters::MONTHLY)
        result = mock_concern.get_income_statement(auth, hist_parameters)
        assert result['income_statements'].length > 0
    end
    
end
