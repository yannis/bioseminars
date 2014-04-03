require 'spec_helper'

describe Building do
  # it_behaves_like "a model with permissions"

  it {should have_many :locations}
  it {should respond_to :name}
  it {should validate_presence_of :name}
  it {should validate_uniqueness_of :name}
end

describe "A building" do
  let(:building){create :building}
  it {expect(building).to be_valid_verbose}

  # context "with a location" do
  #   before {create :location, building_id: building.id}
  #   it {expect(building).to_not be_destroyable}
  # end
end

describe "3 buildings and 2 users" do
  let!(:admin){create :user, admin: true}
  let!(:member){create :user}
  let!(:building1){create :building}
  let!(:building2){create :building}
  let!(:building3){create :building}
  let!(:location){create :location, building_id: building3.id }
end
