FactoryGirl.define do
  # define an incremental username
  sequence :name do |n|
    n.to_s
  end

  sequence :integer do |n|
    n
  end

  sequence :hex_color do
    "#%06x" % (rand * 0xffffff)
  end

  factory :building do
    name {Faker::Company.name}
  end

  factory :category do
    name {Faker::Company.name}
    acronym {|c| c.name.upcase}
    color {generate :hex_color}
  end

  factory :categorisation do
    association :category
    association :seminar
  end

  factory :document do
    data File.new("#{Rails.root}/spec/support/files/a_pdf.pdf")
    association :documentable, factory: :seminar
  end

  factory :host do
    name {"#{Faker::Name.first_name} #{Faker::Name.last_name}"}
    email {Faker::Internet.email}
  end

  factory :hosting do
    association :host
    association :seminar
  end

  factory :location do
    name {Faker::Company.name}
    # association :building not mandatory
    association :building
  end

  factory :seminar do
    title { Faker::Name.title }
    speaker_name {"#{Faker::Name.first_name} #{Faker::Name.last_name}"}
    speaker_affiliation {Faker::Company.name}
    association :location
    association :user
    # categorisations_attributes {{one: {category_id: create(:category).id}}}
    categories {[create(:category)]}
    hosts {[create(:host)]}
    start_at { 2.weeks.since }
  end

  factory :user do
    name {"#{Faker::Name.first_name} #{Faker::Name.last_name}"}
    email {Faker::Internet.email}
    password {Faker::Internet.password+Faker::Internet.password}
    password_confirmation {|a| a.password}
  end
end
