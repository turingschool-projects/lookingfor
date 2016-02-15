class JobFetcher
  def self.create_records(entry)
    self.find_or_create_company(entry)
  end

  def self.find_or_create_company(entry)
    Company.where('lower(name) = ?', entry[:company_name].downcase)
      .first_or_create(name: entry[:company_name])
  end
end
