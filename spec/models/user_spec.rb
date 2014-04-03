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

#   describe "When Jaquet is searched through LDAP," do
#     let(:users) {User.ldap('Jaquet')}

#     it {users.should_not be_empty}

#     it "find a user with full_name == Yannis Jaquet" do
#       users.detect{|u| u.full_name == 'Yannis Jaquet'}.should_not be_nil
#     end

#     it "find  Yannis Jaquet" do
#       users.map(&:full_name).should include 'Yannis Jaquet'
#     end

#     it "not find a user with last_name == Paquet" do
#       users.select{|u| u.last_name == 'Paquet'}.should be_blank
#     end
#   end

#   describe "3 users, " do
#     let!(:user1) {FactoryGirl.create :user}
#     let(:user2) {FactoryGirl.create :user}
#     let(:user3) {FactoryGirl.create :user}

#     it "find no active user" do
#       User.active.should =~ []
#     end

#     describe "if user2 has a current activity and user1 a past activity," do
#       let(:unit1){FactoryGirl.create :unit}
#       before do
#         user1.activities.create(:unit_id => FactoryGirl.create(:unit).id, :start_on => 1.year.ago, :stop_on => 6.months.ago)
#         user2.activities.create(:unit_id => unit1.id, :start_on => 1.year.ago, :function_id => FactoryGirl.create(:function, :name_en => 'Chief of the world').id)
#       end

#       it "find only one active user" do
#         User.active.should =~ [user2]
#       end

#       it {user2.should be_currently_active}
#       it {user2.current_activities.should_not be_empty}
#       it {user2.past_activities.should be_empty}
#       it {user2.functions.first.name.should == 'Chief of the world'}
#       it {user2.current_units.should =~ [unit1]}
#       it {user1.should_not be_currently_active}
#       it {user1.current_activities.should be_empty}
#       it {user1.past_activities.should_not be_empty}
#       it {user1.functions.should be_blank}
#       it {user1.current_units.should be_empty}
#       it {user3.should_not be_currently_active}
#       it {user3.current_activities.should be_empty}
#       it {user3.past_activities.should be_empty}
#       it {user3.functions.should be_blank}
#       it {user3.current_units.should be_empty}
#     end

#     describe "if user1 is called Robert Bidochon" do
#       before {user1.update_attributes(:first_name => 'Robert', :last_name => 'Bidochon')}

#       it {user1.full_name.should == 'Robert Bidochon'}
#       it {user1.short_name.should == 'R. Bidochon'}
#       it {user1.role.should == :basic}
#       it {user1.should_not be_admin}
#       it {user1.should_not be_pi}

#       context "if she has a unit" do
#         let!(:unit) {FactoryGirl.create(:unit, :user_id => user1.id)}
#         # before { user1.reload}
#         it {user1.should be_pi}
#         it {user1.should be_labadmin}
#       end
#     end
#   end
#   describe "UserObserver" do
#     let!(:orphan_picture){FactoryGirl.create(:picture, :model_id => nil, :model_type => 'User')}
#     it{orphan_picture.should be_persisted}
#     it{orphan_picture.model_id.should be_nil}
#     it{orphan_picture.model_type.should == 'User'}
#     it "deletes orphaned pictures when a user is saved" do
#       Picture.orphan.count.should == 1
#       FactoryGirl.create :user
#       Picture.orphan.count.should == 0
#       # expect {
#       #   user = FactoryGirl.create :user
#       # }.to change(Picture, :count).by -1
#     end
#     it "raise 'This is last admin: do not destroy!'" do
#       thisuser = FactoryGirl.create :user, :admin => true
#       expect {
#         User.destroy thisuser
#       }.to raise_error RuntimeError, 'This is last admin: do not destroy!'
#     end
#   end
# end
