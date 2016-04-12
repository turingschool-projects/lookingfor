namespace :job_fetch do
  desc "Run the stack overflow fetcher"

  task all_jobs: :environment do
    Technology.find_each do |t|
      StackOverflow.new(t.name).scrape
    end
    WeWorkRemotely.scrape
  end

end
