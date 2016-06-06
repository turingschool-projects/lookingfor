class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :url, :location, :posted_date, :remote
  has_one :company
  has_many :technologies
end
