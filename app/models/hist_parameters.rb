# this class describe an hist parameters given and received by the application
class HistParameters
    
    #Simple Enum Implementation (http://stackoverflow.com/a/5675566/1107536)
    PERIOD_TYPE = [YEARLY = 'YEARLY', MONTHLY = 'MONTHLY', WEEKLY = 'WEEKLY', DAILY = 'DAILY']
    
    #date format used for http exchange
    DATE_FORMAT = '%Y-%m-%d'
    
    def initialize(from, to, period)
        if (from > to)
          raise ArgumentError.new("from must be less than to: {#from}, {#to}")
        end
        if (!PERIOD_TYPE.include? period)
          raise ArgumentError.new("period:#{period} must be: #{PERIOD_TYPE}")
        end
        @from = from
        @to = to
        @period = period
    end
    
    attr_reader :from, :to, :period
    
    def self.from_http_parameters(parameters)
      from = Date.strptime(parameters['from'], DATE_FORMAT)
      to = Date.strptime(parameters['to'], DATE_FORMAT)
      period = parameters['period']
      HistParameters.new(from, to, period)
    end
    
    def to_http_query
      {:from => @from.strftime(DATE_FORMAT), :to => @to.strftime(DATE_FORMAT), :period => period}
    end
    
    def ==(other_object)
      other_object.from == @from && other_object.to == @to && other_object.period == @period
    end
end
