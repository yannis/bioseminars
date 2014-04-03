xml.instruct!
xml.seminars do
  @seminars.each do |seminar|
    xml.seminar do
      xml.id seminar.id, type: 'Integer'
      xml.title seminar.title, type: 'String'
      xml.speaker type: 'Array' do
        xml.name seminar.speaker_name, type: 'String'
        xml.affiliation seminar.speaker_affiliation, type: 'String'
      end
      xml.hosts type: 'Array' do
        seminar.hosts.each do |h|
          xml.host do
            xml.name h.name, type: 'String'
            xml.email h.email, type: 'String'
          end
        end
      end
      xml.categories type: 'Array' do
        seminar.categories.each do |c|
          xml.category do
            xml.name c.name, type: 'String'
            xml.acronym c.acronym, type: 'String'
          end
        end
      end
      xml.location do
        xml.name seminar.location.name, type: 'String'
        xml.building do
          xml.name seminar.location.building.name, type: 'String'
        end
      end
      xml.all_day seminar.all_day?, type: 'Boolean'
      xml.start_at seminar.start_at, type: 'DateTime'
      xml.end_at seminar.end_at, type: 'DateTime'
      xml.internal seminar.internal?, type: 'Boolean'
      xml.url seminar.url, type: 'String'
      xml.pubmed_ids seminar.pubmed_ids, type: 'String'
      xml.description seminar.description, type: 'String'
      xml.schedule seminar.schedule, type: 'String'
    end
  end
end
