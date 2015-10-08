require 'test_helper'

class ApplicationTest < ActionController::TestCase
    test "environment variables" do
        assert_not_nil ENV["CONNEC_ENDPOINT"]
        assert_not_nil ENV["GROUP_ID"]
        assert_not_nil ENV["API_KEY"]
        assert_not_nil ENV["API_SECRET"]
    end
end
