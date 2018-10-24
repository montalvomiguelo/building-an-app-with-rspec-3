require_relative '../../app/api'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API', :db do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API
    end

    it 'records submitted expenses' do
      coffee = post_expense(
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      )

      zoo = post_expense(
        'payee' => 'Zoo',
        'amount' => 15.25,
        'date' => '2017-06-10'
      )

      groceries = post_expense(
        'payee' => 'Whole Foods',
        'amount' => 95.20,
        'date' => '2017-06-11'
      )

      get '/expenses/2017-06-10'
      expect(last_response.status).to eq(200)

      expenses = JSON.parse(last_response.body)
      expect(expenses).to contain_exactly(coffee, zoo)
    end

    it 'retreives expenses in XML format' do
      coffee = post_expense(
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      )

      zoo = post_expense(
        'payee' => 'Zoo',
        'amount' => 15.25,
        'date' => '2017-06-11'
      )

      get '/expenses/2017-06-10', {}, { 'CONTENT_TYPE' => 'text/xml' }

      xml_doc = Nokogiri::Slop(last_response.body)
      expenses = xml_doc.xpath('//expenses/expense')
      expense = expenses.first

      expect(expenses.count).to eq(1)
      expect(expense.id.content).to eq(coffee['id'].to_s)
      expect(expense.payee.content).to eq(coffee['payee'].to_s)
      expect(expense.amount.content).to eq(coffee['amount'].to_s)
      expect(expense.date.content).to eq(coffee['date'].to_s)
    end

    def post_expense(expense)
      post '/expenses', expense.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq(200)

      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => parsed['expense_id'])
    end
  end
end
