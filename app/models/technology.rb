class Technology < ActiveRecord::Base
  validates :name, presence: true
  has_and_belongs_to_many :jobs
  before_save { |tech| tech.name = tech.name.downcase }
end
