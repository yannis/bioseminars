require "spec_helper"

describe Permissions::GuestPermission do
  subject { Permissions.permission_for(nil) }

  it "allows application" do
    should allow_action :application, :index
  end

  it "allows buildings" do
    should allow_action :buildings, :index
    should allow_action :buildings, :show
    should_not allow_action :buildings, :create
    should_not allow_action :buildings, :update
    should_not allow_action :buildings, :destroy

    should_not allow_param :building, :name
  end

  it "allows categories" do
    should allow_action :categories, :index
    should allow_action :categories, :show
    should_not allow_action :categories, :create
    should_not allow_action :categories, :update
    should_not allow_action :categories, :destroy

    should_not allow_param :category, :name
    should_not allow_param :category, :description
    should_not allow_param :category, :acronym
    should_not allow_param :category, :color
  end

  it "allows hosts" do
    should allow_action :hosts, :index
    should allow_action :hosts, :show
    should_not allow_action :hosts, :create
    should_not allow_action :hosts, :update
    should_not allow_action :hosts, :destroy

    should_not allow_param :host, :name
  end

  it "allows locations" do
    should allow_action :locations, :index
    should allow_action :locations, :show
    should_not allow_action :locations, :create
    should_not allow_action :locations, :update
    should_not allow_action :locations, :destroy

    should_not allow_param :location, [:name, :building_id]
  end

  it "allows seminars" do
    should allow_action :seminars, :index
    should allow_action :seminars, :show
    should_not allow_action :seminars, :create
    should_not allow_action :seminars, :update
    should_not allow_action :seminars, :destroy

    should_not allow_param :seminar, :name
  end

  it "allows users" do
    should_not allow_action :users, :index
    should_not allow_action :users, :show
    should_not allow_action :users, :create
    should_not allow_action :users, :update
    should_not allow_action :users, :destroy

    should_not allow_param :users, [:name, :email, :admin]
  end

  it "allows sessions" do
    # should allow(:sessions, :new)
    should allow_action(:sessions, :create)
    should allow_action(:sessions, :destroy)
  end


end
