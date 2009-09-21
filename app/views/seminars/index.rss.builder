xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "Seminars"
    xml.description "Next seminars in the biology section of the University of Geneva"
    xml.link seminars_url
    xml.webMaster "Yannis.Jaquet@unige.ch"
    for seminar in @seminars.sort{|x,y| y.start_on <=> x.start_on }
      xml.item do
        xml.title seminar.date_time_location_and_category
        total_description = []
        total_description << "<h3>#{seminar.speakers[0..1].map{|s| s.name+' ('+s.affiliation+')'}}</h3>"
        total_description << "<h4>“#{seminar.title}”</h4>"
        total_description << "<p>#{seminar.description}</p>" if seminar.description
        total_description << "<p>Hosted by #{seminar.hosts.map(&:name).join(', ')}</p>" unless seminar.hosts.blank?
        total_description << " (#{link_to('website', seminar.url)})" if seminar.url
        xml.description total_description.join
        xml.pubDate seminar.created_at.to_s(:rfc822)
        xml.link seminar_url(seminar)
        xml.guid seminar_url(seminar)
      end
    end
  end
end
