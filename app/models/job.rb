class Job < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  before_save { |tech| tech.downcase_tech }
  after_save :job_to_elasticsearch

  scope :by_date, -> { order(posted_date: :desc) }
  scope :last_two_months, -> { where("posted_date >= ?", 2.months.ago)}

  belongs_to :company
  has_and_belongs_to_many :technologies


  def downcase_tech
    self.raw_technologies = self.raw_technologies.compact.map(&:downcase)
  end

  def assign_tech
    tech_matches = Technology.where(name: raw_technologies)
    self.technologies = tech_matches
  end

private
  def job_to_elasticsearch
    client = Elasticsearch::Client.new log: true
    client.index(index: "looking-for",
                 type: "job",
                 id: self.id,
                 body: {title: self.title,
                       description: self.description,
                       url: self.url,
                       location: self.location,
                       posted_date: self.posted_date,
                       remote: self.remote,
                       technologies: self.raw_technologies,
                       company: Company.find(self.company_id).name})
  end
end
