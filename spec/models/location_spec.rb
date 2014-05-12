require 'spec_helper'
# require "model_permissions_spec"

describe Location do
  # it_behaves_like "a model with permissions"

  it {should respond_to :name}
  it {should respond_to :building}

  it {should belong_to :building}
  it {should have_many :seminars}

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of(:name).scoped_to :building_id}
end

describe "A location" do
  let(:location){create :location, name: "room4059", building: nil}
  it {expect(location).to be_valid_verbose}
  it {expect(location.name_and_building).to eq "room4059"}
  context "with a building" do
    let(:building) {create :building, name: "ScIII ()"}
    before {location.update_attributes building: building}
    it {expect(location.name_and_building).to eq "room4059 (ScIII)"}
  end
end
