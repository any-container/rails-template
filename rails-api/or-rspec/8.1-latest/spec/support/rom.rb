# Runs ROM migrations once, then wraps each example in a rolled-back transaction.
RSpec.configure do |config|
  config.before(:suite) do
    RomContainer.migrate
  end

  config.around do |example|
    RomContainer.gateway.connection.transaction(rollback: :always, auto_savepoint: true) { example.run }
  end
end
