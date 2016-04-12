namespace :job_fetch do
  desc "Run all job fetchers"

  task all_jobs: :environment do
    ["stackoverflow", "weworkremotely"].each { |t| build t }
  end

  desc "Run stack overflow job fetcher"

  task stackoverflow: :environment do
    Technology.find_each do |t|
      StackOverflow.new(t.name).scrape
    end
  end

  desc "we work remotely job fetcher"

  task weworkremotely: :environment do
    WeWorkRemotely.scrape
  end

  desc "the build task calls each rake task individually"

  def build(type)
    Rake::Task["job_fetch:#{type}"].invoke
  end
end
