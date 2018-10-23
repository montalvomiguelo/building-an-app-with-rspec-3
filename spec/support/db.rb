RSpec.configure do |config|
  config.before(:suite) do
    Sequel.extension :migration
    Sequel::Migrator.run(DB, 'db/migrate')
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:example, :db) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
