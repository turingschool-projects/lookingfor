class Job < ActiveRecord::Base
  validates :title, presence: true
  validates :url, presence: true, uniqueness: true

  before_save { |tech| tech.downcase_tech }

  scope :by_date, -> { order(posted_date: :desc) }
  scope :last_two_months, -> { where("posted_date >= ?", 2.month.ago).order(posted_date: :desc) }

  belongs_to :company
  has_and_belongs_to_many :technologies
  belongs_to :location

  def self.by_location(search_location)
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

  def self.current_openings_technology_count
    Technology.all.map do |tech|
      {label: tech.name, value: last_two_months.by_tech(tech.name).count}
    end
  end
end
