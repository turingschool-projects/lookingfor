class JobSerializer < ActiveModel::Serializer
  attributes :title, :description, :url, :location, :posted_date, :remote, :raw_technologies
  has_one :company
end
