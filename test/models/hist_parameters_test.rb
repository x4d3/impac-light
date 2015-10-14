require 'test_helper'

class HistParametersTest < ActionController::TestCase
    require 'Date'
    
    test "normal HistParameters usage" do
      hp1 = HistParameters.new(DateTime.new(2000,1,1), DateTime.new(2001,1,1), HistParameters::MONTHLY)
      hp2 = HistParameters.from_http_parameters({'from' => '2000-01-01', 'to' => '2001-01-01', 'period' => 'MONTHLY'})
      assert_equal(hp1, hp2)
      assert_equal(hp1.to_http_query,  {:from => '2000-01-01', :to => '2001-01-01', :period => 'MONTHLY'})
    end
    
    test "bad arguments raise ArgumentError" do
      assert_raise ArgumentError do 
        HistParameters.new(DateTime.new(2001,1,1), DateTime.new(2000,1,1), HistParameters::MONTHLY)
      end
      assert_raise ArgumentError do 
        HistParameters.new(DateTime.new(2000,1,1), DateTime.new(2001,1,1), 'SECONDLY')
      end
      assert_raise ArgumentError do 
        HistParameters.from_http_parameters({'from' => '2003-1-1', 'to' => '2001-1-1', 'period' => 'MONTHLY'})
      end
    end
end
