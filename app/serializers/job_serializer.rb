class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :url, :location, :posted_date, :remote
  has_one :company
  has_many :technologies

  def location
    object.location.name
  end

end
