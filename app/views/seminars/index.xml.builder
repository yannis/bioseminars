xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.Seminars :type => 'Array' do
  for seminar in @seminars
    xml.Seminar do
      xml.Title seminar.mini_seminar_title, :type => 'String' unless seminar.mini_seminar_title.blank?
      xml.Speakers :type => 'Array' do
        for speaker in seminar.speakers
          xml.Speaker do
            xml.Name speaker.name, :type => 'String' unless speaker.name.blank?
            xml.Affiliation speaker.affiliation, :type => 'String' unless speaker.affiliation.blank?
          end
        end
      end
      xml.Hosts :type => 'Array' do
        for host in seminar.hosts
          xml.Host do
            xml.Name host.name, :type => 'String' unless host.name.blank?
            xml.Email host.email, :type => 'String' unless host.email.blank?
          end
        end
      end
      xml.Category seminar.category.name, :type => 'String' if seminar.category
      xml.Location seminar.location.name, :type => 'String' if seminar.location
      xml.Building seminar.location.building.name, :type => 'String' if seminar.location and seminar.location.building
      xml.All_day seminar.all_day?, :type => 'Boolean'
      xml.Start_at( seminar.start_on.to_s(:db), :type => 'DateTime') if seminar.start_on
      xml.End_at( seminar.end_on.to_s(:db), :type => 'DateTime') if seminar.end_on
      xml.Internal seminar.internal?, :type => 'Boolean'
      xml.Url seminar.url, :type => 'String'
      xml.Pubmed_ids seminar.pubmed_ids, :type => 'String'
      xml.Description seminar.description, :type => 'String'
    end
  end
end