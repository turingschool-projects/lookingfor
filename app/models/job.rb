class Job < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  before_save { |tech| tech.downcase_tech }

  scope :by_date, -> { order(posted_date: :desc) }
  scope :last_two_months, -> { where("posted_date >= ?", 2.month.ago).order(posted_date: :desc) }

  belongs_to :company
  has_and_belongs_to_many :technologies
  belongs_to :location

  def self.by_location(search_location)
    # where("lower(location) LIKE ?", "%#{search_location.downcase}%")
    # binding.pry
    joins(:location).where("lower(name) LIKE ?", "%#{search_location.downcase}%")
  end

  def downcase_tech
    self.raw_technologies = self.raw_technologies.compact.map(&:downcase)
  end

  def assign_tech
    tech_matches = Technology.where(name: raw_technologies)
    self.technologies = tech_matches
  end

  def self.by_tech(tech_name)
    joins(:technologies).where(technologies: {name: tech_name.downcase})
  end

  def self.total_pages(num_of_items_per_page)
    calculation = last_two_months.count / num_of_items_per_page.to_f
    calculation.ceil
  end

  def self.technologies_by_month
    # Will serve as a trailing data set (for 6 months or whatever the limit is)
    # For each month, count the number of job postings that contain a certain technology
    # Export some array like:
    # [[Technology Headers],
    # [month_date1, tech1_num, tech2_num],
    # [month_date2, tech1_num, tech2_num],
    # [month_date3, tech1_num, tech2_num],
    # [.],
    # [.],
    # [.]]
  end
end
