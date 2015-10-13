module Api::V1::Accounts
  # Returns the sums of the accounts of category EXPENSE and the sum of those of category REVENUE throughout a given period of time.
  # Example:
  # {
  #     "organizations": ["org-abcd","org-qwer"],
  #     "values": {
  #         "expenses": [42587.32, 41587.54, 40558.45],
  #         "revenue": [55871.33, 54887.66, 53669.24]
  #     }
  #     "currency": "EUR",
  #     "dates": ["2015-01-01", "2015-02-01", "2015-02-14"],
  #     "hist_parameters": {
  #         "from": "2015-01-01",
  #         "to": "2015-02-14",
  #         "period": "MONTHLY"
  #     }
  # }
  class ExpensesRevenueController < ApiController
    def index
    end
  end
end
