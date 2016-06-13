class TechnologySerializer < ActiveModel::Serializer
  attributes :id, :name

  def name
    tech_capitalizations[object.name] ?
    tech_capitalizations[object.name] : object.name.split.map(&:capitalize)*' '
  end

  def tech_capitalizations
    {
      "javascript" => "JavaScript",
    }
  end
end
