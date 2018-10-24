module ExpenseTracker
  class API < Sinatra::Base
    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super()
    end

    def expenses_xml(expenses)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.expenses {
          expenses.each do |expense|
            if expense.respond_to? 'each'
              xml.expense {
                expense.each { |key, value| xml.send("#{key}_", value) }
              }
            else
              xml.expense expense
            end
          end
        }
      end

      builder.to_xml
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

      if request.content_type === 'text/xml'
        halt 200, { 'Content-Type' => 'text/xml' }, expenses_xml(result)
      end

      json result
    end
  end
end
