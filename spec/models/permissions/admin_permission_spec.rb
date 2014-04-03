require "spec_helper"

describe Permissions::AdminPermission do

  let(:user) { create :user, admin: true }
  let(:building) { create :building }
  let(:building2) { create :building }
  let(:category) { create :category }
  let(:host) { create :host }
  let!(:location) { create :location, building_id: building2.id }
  let(:seminar) {create :seminar}
  let(:seminar2) {create :seminar, user: user}

  subject { Permissions.permission_for(user) }

  it "allows any params" do
    # should allow_action :any, :thing
    should allow_param :any, :thing
  end

  it "allows application" do
    should allow_action :application, :index
  end

  it "allows buildings" do
    should allow_action :buildings, :index
    should allow_action :buildings, :show
    should allow_action :buildings, :create
    should allow_action :buildings, :update
    should allow_action :buildings, :destroy, building
    should_not allow_action :buildings, :destroy, building2
  end

  it "allows categories" do
    should allow_action :categories, :index
    should allow_action :categories, :show
    should allow_action :categories, :create
    should allow_action :categories, :update
    should allow_action :categories, :destroy, category
  end

  it "allows hosts" do
    should allow_action :hosts, :index
    should allow_action :hosts, :show
    should allow_action :hosts, :create
    should allow_action :hosts, :update
    should allow_action :hosts, :destroy, host
  end

  it "allows locations" do
    should allow_action :locations, :index
    should allow_action :locations, :show
    should allow_action :locations, :create
    should allow_action :locations, :update
    should allow_action :locations, :destroy, location
  end

  it "allows seminars" do
    should allow_action :seminars, :index
    should allow_action :seminars, :show
    should allow_action :seminars, :create
    should allow_action :seminars, :update, seminar
    should allow_action :seminars, :update, seminar2
    should allow_action :seminars, :destroy, seminar
    should allow_action :seminars, :destroy, seminar2

    should allow_param :seminar, :title
    should allow_param :seminar, :speaker_name
    should allow_param :seminar, :speaker_affiliation
    should allow_param :seminar, :start_at
    should allow_param :seminar, :end_at
    should allow_param :seminar, :location_id
    should allow_param :seminar, :url
    should allow_param :seminar, :pubmed_ids
    should allow_param :seminar, :all_day
    should allow_param :seminar, :internal
    should allow_param :seminar, :hostings_attributes
    should allow_param :seminar, :documents_attributes
    should allow_param :seminar, :user_id
  end

  it "allows users" do
    should allow_action :users, :index
    should allow_action :users, :show, user
    should allow_action :users, :update, user
  end
end
