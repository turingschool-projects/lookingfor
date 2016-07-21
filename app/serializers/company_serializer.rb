class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :jobs, serializer: JobForCompanySerializer
end
