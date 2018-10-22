module ExpenseTracker
  class API < Sinatra::Base
    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super()
    end

    post '/expenses' do
      request.body.rewind
      data = JSON.parse request.body.read
      result = @ledger.record(data)
      json :expense_id => result.expense_id
    end

    get '/expenses/:date' do
      json []
    end
  end
end
