xml.instruct! :xml, :version => "1.0"
xml.rss version: "2.0", "xmlns:blogChannel" => "http://backend.userland.com/blogChannelModule",  "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.tag! "atom:link", href: request.url, rel: "self", type: "application/rss+xml"
    xml.title "Life science seminars at the biology section of the University of Geneva"
    xml.description "Life science seminars at the biology section of the University of Geneva"
    xml.link root_url
    xml.webMaster "Yannis.Jaquet@unige.ch (Yannis Jaquet)"
    for seminar in @seminars
      xml.item do
        xml.title "#{seminar.schedule} | #{seminar.location.name_and_building} | #{seminar.categories.map(&:acronym).compact.join(', ')}"
        total_description = []
        total_description << "<h3>#{seminar.speaker_name_and_affiliation}}</h3>"
        total_description << "<h4>“#{seminar.title}”</h4>"
        total_description << "<p>#{seminar.description}</p>" if seminar.description
        total_description << "<p>Hosted by #{seminar.hosts.map{|s| mail_to(s.email, s.name, :encode => 'hex')}.join(', ')}</p>" unless seminar.hosts.blank?
        total_description << " (#{link_to('website', seminar.url)})" unless seminar.url.blank?
        xml.description total_description.join
        xml.pubDate seminar.created_at.to_s(:rfc822)
        xml.link "http://#{request.host}#{seminar.ember_path}"
        xml.guid "http://#{request.host}#{seminar.ember_path}"
      end
    end
  end
end
