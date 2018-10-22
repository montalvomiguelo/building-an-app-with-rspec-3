require_relative '../../../app/api'

module ExpenseTracker
  RSpec.describe API do
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do
        let(:expense) { { 'some' => 'data' } }

        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do
          post_json '/expenses', expense.to_json

          expect(parsed).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post_json '/expenses', expense.to_json
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        let(:expense) { { 'some' => 'data' } }

        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end

        it 'returns an error message' do
          post_json '/expenses', expense.to_json

          expect(parsed).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (nprocessable entity)' do
          post_json '/expenses', expense.to_json

          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET /expenses/:date' do
      context 'when expenses exist on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
            .with('2017-06-10')
            .and_return(['coffee', 'zoo'])
        end

        it 'returns the expense records as JSON' do
          get '/expenses/2017-06-10'

          expect(parsed).to eq ['coffee', 'zoo']
        end

        it 'responsts with a 200 (OK)' do
          get '/expenses/2017-06-10'

          expect(last_response.status).to eq(200)
        end
      end

      context 'when there are no expenses on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
            .with('2017-06-11')
            .and_return([])
        end

        it 'returns an empty array as JSON' do
          get '/expenses/2017-06-11'

          expect(parsed).to eq([])
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2017-06-11'

          expect(last_response.status).to eq(200)
        end
      end
    end

    def parsed
      JSON.parse(last_response.body)
    end

    def post_json(uri, json)
      post uri, json, { 'CONTENT_TYPE' => 'application/json' }
    end
  end
end
