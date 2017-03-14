namespace :job_fetch do
  desc "Run all job fetchers"

  task all_jobs: :environment do
    ["stackoverflow", "weworkremotely", "authenticjobs", "github"].each { |t| build t }
  end

  desc "Run stack overflow job fetcher"

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

  desc "Run the github fetcher"

  task github: :environment do
    GithubService.subscribe_and_create_jobs
  end

  desc "the build task calls each rake task individually"

  def build(type)
    Rake::Task["job_fetch:#{type}"].invoke
  end

  desc "Start to Job creator"

  task joblistener: :environment do
    puts "Starting job creator"
    JobCreator.start
  end

end
