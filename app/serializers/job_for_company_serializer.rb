class JobForCompanySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :url, :location, :posted_date, :remote
  has_many :technologies

  def location
    object.location.name if object.location
  end

end
