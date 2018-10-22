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
      unless result.success?
        halt 422, json(:error => result.error_message)
      end
      json :expense_id => result.expense_id
    end

    get '/expenses/:date' do
      result = @ledger.expenses_on(params[:date])
      json result
    end
  end
end
