class JobFetcher
  def create_records(entry)
    self.class.create_records(entry)
  end

  def self.create_records(entry)
    company = self.find_or_create_company(entry[:company])
    self.create_job(entry[:job], company)
  end

  def self.find_or_create_company(company)
    Company.where('lower(name) = ?', company[:name].downcase)
      .first_or_create(name: company[:name])
  end

  def self.create_job(job_attributes, company)
    job = company.jobs.where(title: job_attributes[:title])
      .first_or_create(job_attributes)
    job.assign_tech if job
  end

  def self.technologies
    Technology.pluck(:name)
  end
end
