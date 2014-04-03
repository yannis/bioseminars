xml.instruct! :xml, version: "1.0"
xml.feed "xml:lang" => "en-US", "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "Seminars", type: 'html'
  xml.subtitle "Next seminars in the biology section of the University of Geneva", type: 'html'
  xml.author do
    xml.name "Yannis Jaquet"
    xml.email "yannis.jaquet@unige.ch"
  end
  xml.link rel: 'alternate', href: root_url
  xml.link rel: 'self', href: request.url
  xml.id root_url
  xml.updated Time.now.at_beginning_of_hour.to_s(:rfc3339)
  for seminar in @seminars
    xml.entry "xmlns" => "http://www.w3.org/2005/Atom" do
      xml.title "#{seminar.schedule} | #{seminar.location.name_and_building} | #{seminar.categories.map(&:acronym).compact.join(', ')}"
      total_description = []
      total_description << "<h3>#{seminar.speaker_name_and_affiliation}}</h3>"
      total_description << "<h4>“#{seminar.title}”</h4>"
      total_description << "<p>#{seminar.description}</p>" if seminar.description
      total_description << "<p>Hosted by #{seminar.hosts.map{|s| mail_to(s.email, s.name, :encode => 'hex')}.join(', ')}</p>" unless seminar.hosts.blank?
      total_description << " (#{link_to('website', seminar.url)})" unless seminar.url.blank?
      xml.content total_description.join, type: 'html'
      xml.link href: "http://#{request.host}#{seminar.ember_path}"
      xml.id "http://#{request.host}#{seminar.ember_path}"
      xml.updated seminar.updated_at.to_s(:rfc3339)
    end
  end
end
