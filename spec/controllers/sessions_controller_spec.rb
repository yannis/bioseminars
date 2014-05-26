require 'spec_helper'

describe SessionsController do
  let(:user){create :user, password: "12345678"}

  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  context "as guest" do
    describe "POST 'create'" do
      before {post :create, user: {email: user.email, password: "12345678"}, format: 'json'}
      it {expect(response.status).to eql 201}
      it {expect(response.body).to eql "{\"user_token\":\"#{user.reload.authentication_token}\",\"user_email\":\"#{user.email}\",\"user_id\":#{user.reload.id}}"}
    end

    describe "DELETE 'destroy'" do
      before {delete :destroy, format: 'json'}
      it {expect(response.status).to eql 202}
      it {expect(response.body).to eql "no user signed in"}
    end
  end

  context "as member" do
    let(:member){create :user}
    before {sign_in member}

    describe "POST 'create'" do
      before {post :create, user: {email: user.email, password: "12345678"}, format: 'json'}
      it {expect(response.status).to eql 201}
      it {expect(response.body).to eql "{\"user_token\":\"#{user.reload.authentication_token}\",\"user_email\":\"#{user.email}\",\"user_id\":#{user.id}}"} # already signed in
    end

    describe "DELETE 'destroy'" do
      before {delete :destroy, format: 'json'}
      it {expect(response.status).to eql 202}
      it {expect(response.body).to eql "{}"}
    end
  end
end
