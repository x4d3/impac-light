require "rails_helper"

RSpec.describe Api::V1::Accounts::ExpensesRevenueController, :type => :controller do
  # login to http basic auth
  before(:each) do
    user = ENVied.API_KEY
    pw = ENVied.API_SECRET
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  end
  describe "GET #index" do
    it "fails if there is no parameters" do
      expect{get :index}.to raise_error(ActionController::ParameterMissing)
    end
    it "fails if there is an invalid parameter" do
      expect{get :index, :organization_ids => 'test'}.to raise_error(Api::V1::InvalidParameterError)
    end
    it "responds successfully with an HTTP 200 status code" do
      get :index, :organization_ids => [ENVied.GROUP_ID]
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
    it "responds successfully with an HTTP 200 status code with hist_parameters" do
      get :index, :organization_ids => [ENVied.GROUP_ID], :hist_parameters => '{"from":"2015-01-01","to":"2015-02-14","period":"MONTHLY"}'
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
    it "fails with wrong hist_parameters" do
      expect{get :index, :organization_ids => [ENVied.GROUP_ID], :hist_parameters => 'wrong_value'}.to raise_error(JSON::ParserError)
      expect{get :index, :organization_ids => [ENVied.GROUP_ID], :hist_parameters => '{"from":"2015-01-01","to":"2005-02-14","period":"MONTHLY"}'}.to raise_error(ArgumentError)
    end
  end
end
