# frozen_string_literal: true

require "openhtmltopdf"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Tests that spawn Java are tagged :integration and can be skipped with
  #   rspec --tag ~integration
  config.before(:each, :integration) do
    skip "java not on PATH" unless system("java", "-version", out: File::NULL, err: File::NULL)
  end
end
