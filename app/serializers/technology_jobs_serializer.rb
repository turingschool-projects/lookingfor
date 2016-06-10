class TechnologyJobsSerializer < ActiveModel::Serializer
  attributes :name
  has_many :jobs
end
