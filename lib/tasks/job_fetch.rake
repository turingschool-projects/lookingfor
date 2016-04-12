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

  desc "Run the authentic jobs fetcher"

  task authenticjobs: :environment do
    Technology.find_each do |t|
      AuthenticJobsService.scrape(t.name)
    end
  end
end
