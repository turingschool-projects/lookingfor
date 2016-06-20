require 'load_script/job_endpoints'

namespace :load_script do
  desc "Run a load testing script against app. Accepts 'HOST' as an argument. Defaults to 'localhost:3000'."
  task run: :environment do
    LoadScript::Job_Endpoints.new(ARGV[1]).run
  end
end
