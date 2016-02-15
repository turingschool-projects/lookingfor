class Technology < ActiveRecord::Base
  validates :name, presence: true
  before_save { |tech| tech.name = tech.name.downcase }
end
