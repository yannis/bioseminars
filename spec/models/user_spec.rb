require 'spec_helper'

describe User do
  it {should respond_to :name}
  it {should respond_to :email}
  it {should respond_to :admin}

  it {should have_many :seminars}

  it {should validate_presence_of :name}
  it {should validate_presence_of :email}
  it {should validate_uniqueness_of :email}
end

describe "A basic user" do
  let(:user){build :user}
  it {expect(user).to_not be_admin}
  it {expect(user.authentication_token).to be_nil}
end

describe "A persisted basic user" do
  let(:user){create :user}
  it {expect(user).to be_member}
  it {expect(user.authentication_token).to_not be_nil}
end

describe "An admin user" do
  let(:user){build :user, admin: true}
  it {expect(user).to be_admin}
end

describe "2 users" do
  let!(:admin){create :user, admin: true}
  let!(:member){create :user}

  it {expect(User.loadable_by(admin)).to match_array [admin, member]}
  it {expect(User.loadable_by(member)).to match_array [member]}
  it {expect(User.loadable_by(nil)).to match_array []}
end
