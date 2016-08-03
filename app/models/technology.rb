class Technology < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :jobs
  before_save { |tech| tech.name = tech.name.downcase }

  def self.test_analysis(tech)
    find_by(name: tech).jobs.count
  end
end
