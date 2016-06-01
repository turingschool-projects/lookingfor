class JobSerializer < ActiveModel::Serializer
  attributes :title, :description, :url, :location, :posted_date, :remote, :raw_technologies
  has_one :company

  def location
    object.location.name
  end
end
