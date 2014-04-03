require 'spec_helper'

describe Category do
  it {should respond_to :name}
  it {should respond_to :description}
  it {should respond_to :acronym}
  it {should respond_to :color}
  it {should respond_to :position}
  it {should validate_presence_of :name}
  it {should validate_uniqueness_of :name}
  it {should validate_presence_of :acronym}
  it {should validate_uniqueness_of :acronym}
  it {should validate_presence_of :color}
  it {should validate_uniqueness_of :color}
end

describe "A category" do
  let(:category){create :category}
  it {expect(category).to be_valid_verbose}
  # it {expect(category.color).to eq "jlkljo"}
end
