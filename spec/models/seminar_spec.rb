require 'spec_helper'

describe Seminar do
  it {should respond_to :title}
  it {should respond_to :description}
  it {should respond_to :speaker_name}
  it {should respond_to :speaker_affiliation}
  it {should respond_to :start_at}
  it {should respond_to :end_at}
  it {should respond_to :url}
  it {should respond_to :pubmed_ids}
  it {should respond_to :all_day}
  it {should respond_to :internal}
  it {should respond_to :user}
  it {should respond_to :location}
  it {should respond_to :hostings}
  it {should respond_to :hosts}
  it {should respond_to :categorisations}
  it {should respond_to :categories}

  it {should validate_presence_of :title}
  # it {should validate_uniqueness_of(:title).scoped_to(:speaker_name)}
  it {should validate_presence_of :speaker_name}
  it {should validate_presence_of :speaker_affiliation}
  it {should validate_presence_of :start_at}
  it {should validate_presence_of :user_id}
  it {should validate_presence_of :location_id}

  it {should belong_to :user}
  it {should belong_to :location}
  it {should have_many(:categorisations).dependent(:destroy)}
  it {should have_many :categories}
  it {should have_many(:hostings).dependent(:destroy)}
  it {should have_many :hosts}
  it {should have_many(:documents).dependent(:destroy)}

  # it {should accept_nested_attributes_for(:hostings)}
  # it {should accept_nested_attributes_for(:documents)}

  it "has named_scope" do
    @basic_user = create :user
    @admin_user = create :user, admin: true
    @category = create :category
    @today = create :seminar, title: "today", start_at: Time.current+2.minutes, categories: [@category]
    @two_days_ago = create :seminar, title: "two_days_ago", start_at: 2.days.ago, categories: [@category]
    @in_two_days = create :seminar, title: "in_two_days", start_at: 2.days.from_now, internal: true
    @in_one_month = create :seminar, title: "in_one_month", start_at: 1.months.from_now, user: @basic_user
    @one_month_ago = create :seminar, title: "one_month_ago", start_at: 1.months.ago
    @in_two_months = create :seminar, title: "in_two_months", start_at: 2.months.from_now
    @two_month_ago = create :seminar, title: "two_month_ago", start_at: 2.months.ago

    expect(Seminar.all).to eq [@today, @two_days_ago, @in_two_days, @in_one_month, @one_month_ago, @in_two_months, @two_month_ago]
    expect(Seminar.of_day(Date.current)).to eq [@today]
    expect(Seminar.past.to_a).to match_array [@two_days_ago, @one_month_ago, @two_month_ago]
    expect(Seminar.now_or_future).to eq [@today, @in_two_days, @in_one_month, @in_two_months]
    expect(Seminar.before_date(40.days.ago)).to eq [@two_month_ago]
    expect(Seminar.after_date(40.days.since)).to eq [@in_two_months]
    expect(Seminar.of_categories([@category]).to_a).to eq [@today, @two_days_ago]
    expect(Seminar.next).to eq [@today, @in_two_days, @in_one_month, @in_two_months]
    expect(Seminar.internal(true)).to eq [@in_two_days]
  end
end

describe "A seminar" do
  let(:seminar){create :seminar}
  it {expect(seminar).to be_valid_verbose}
end

