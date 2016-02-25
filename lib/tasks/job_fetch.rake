namespace :job_fetch do
  desc "Run the stack overflow fetcher"

  task stackoverflow: :environment do
    Technology.find_each do |t|
      StackOverflow.new(t.name).scrape
    end
  end

  desc "Run the we work remotely fetcher"

  task weworkremotely: :environment do
    WeWorkRemotely.scrape
  end
end
