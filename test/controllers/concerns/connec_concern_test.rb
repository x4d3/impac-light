require 'test_helper'

class ConnecConcernTest < ActiveSupport::TestCase
    #simple mock object used to test the ConnecConcern module
    connecConcernObj = Object.new
    connecConcernObj.extend(ConnecConcern)
    auth = ConnecAuthentication.new(ENVied.GROUP_ID, ENVied.API_KEY, ENVied.API_SECRET)
    test "getAccounts" do
        accounts = connecConcernObj.getAccounts(auth)
        assert accounts.length > 0
    end
    test "getBalanceSheets" do
        result = connecConcernObj.getBalanceSheets(auth)
        assert result['balance_sheets'].length > 0
    end
    test "getAccountsSummary" do
        result = connecConcernObj.getAccountsSummary(auth)
        assert result['accounts'].length > 0
    end
    test "getIncomeStatement" do
        histParameter = HistParameters.new(DateTime.new(2014,1,1), DateTime.new(2015,1,1), HistParameters::MONTHLY)
        result = connecConcernObj.getIncomeStatement(auth, histParameter)
        assert result['income_statements'].length > 0
    end
    
end
