require 'spec_helper'

describe Host do
  it {should respond_to :name}
  it {should respond_to :email}
  it {should validate_presence_of :name}
  it {should validate_uniqueness_of :name}
  it {should validate_presence_of :email}
  it {should validate_uniqueness_of :email}
end

describe "A host" do
  let(:host) { create :host }
  it {expect(host).to be_valid_verbose}
end

