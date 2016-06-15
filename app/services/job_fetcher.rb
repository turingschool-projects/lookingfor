class JobFetcher
  def create_records(entry)
    self.class.create_records(entry)
  end

  def self.create_records(entry)
    company = self.find_or_create_company(entry[:company])
    location = self.find_or_create_location(entry[:location])
    self.create_job(entry[:job], company, location)
  end

  def self.find_or_create_company(company)
    Company.where('lower(name) = ?', company[:name].downcase)
      .first_or_create(name: company[:name])
  end

  def self.find_or_create_location(location)
    Location.where('lower(name) = ?', location[:name].downcase)
      .first_or_create(name: location[:name])
  end

  def self.create_job(job_attributes, company, location)
    job = company.jobs.where(title: job_attributes[:title])
      .first_or_create(job_attributes)

    location.jobs << job if job
    job.assign_tech if job
  end

  def self.technologies
    Technology.pluck(:name)
  end
end
