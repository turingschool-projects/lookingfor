namespace :one_off_tasks do
  desc "Updates raw_technologies and assigns appropriate tech"

  task fix_technologies: :environment do
    jobs_without_tech.find_each do |job|
      assign_raw_tech(job)
    end
  end

  def jobs_without_tech
    Job.includes(:jobs_technologies)
    .where(jobs_technologies: { technology_id: nil})
  end

  def assign_raw_tech(job)
    base = job.raw_technologies
    additional = []
    raw_tech = job.raw_technologies.join(' ')
    base << 'ruby' if /ruby/ === raw_tech
    base << 'rails' if /rails/ === raw_tech
    base << 'javascript' if /(^| )js/ === raw_tech || /javascript/ === raw_tech
    base << 'ember' if /ember/ === raw_tech
    base << 'angular' if /angular/ === raw_tech
    base << 'react' if /react/ === raw_tech
    base << 'go' if /golang/ === raw_tech
    job.raw_technologies = base | additional
    job.save
    job.assign_tech
  end
end
