class Job < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true

  belongs_to :company
  has_and_belongs_to_many :technologies
end
