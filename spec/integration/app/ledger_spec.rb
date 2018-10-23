require_relative '../../support/db'
require_relative '../../../lib/ledger'

module ExpenseTracker
  RSpec.describe Ledger do
    let(:ledger) { Ledger.new }
    let(:expense) do
      {
        'payee' => 'Startucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      }
    end

    describe '#record'
  end
end
