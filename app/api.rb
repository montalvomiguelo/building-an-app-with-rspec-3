module ExpenseTracker
  class API < Sinatra::Base
    post '/expenses' do
      json :expense_id => 23
    end

    get '/expenses/:date' do
      json []
    end
  end
end
