class Job < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  before_save { |tech| tech.downcase_tech }

  belongs_to :company
  has_and_belongs_to_many :technologies

  def downcase_tech
    self.raw_technologies = self.raw_technologies.compact.map(&:downcase)
  end

  def assign_tech
    tech_matches = Technology.where(name: raw_technologies)
    self.technologies = tech_matches
  end
end
