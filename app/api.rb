module ExpenseTracker
  class API < Sinatra::Base
    post '/expenses' do
      json :expense_id => 23
    end
  end
end
