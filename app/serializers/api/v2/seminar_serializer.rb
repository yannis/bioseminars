class Api::V2::SeminarSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :speaker_name, :speaker_affiliation, :start_at, :end_at, :url, :all_day, :internal, :pubmed_ids, :location, :hosts, :documents, :categories

  def hosts
    object.hosts.map do |h|
      {name: h.name, email: h.email}
    end
  end

  def categories
    object.categories.map do |c|
      {id: c.id, name: c.name, description: c.description, description: c.description, description: c.description, description: c.description}
    end
  end

  def location
    {name: object.location.name, building: {name: object.location.building.name}} if object.location
  end

  def documents
    object.documents.map do |d|
      {name: d.data_file_name, type: d.data_content_type, size: d.data_content_type, url: d.data.url}
    end
  end
end
