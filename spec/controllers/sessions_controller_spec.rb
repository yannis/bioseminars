require 'spec_helper'

describe SessionsController do
  let(:user){create :user, password: "12345678"}

  context "as guest" do
    describe "POST 'create'" do
      before {post :create, session: {email: user.email, password: "12345678"}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(response.body).to eql "{\"session\":{\"user_id\":#{user.reload.id},\"email\":\"#{user.email}\",\"authentication_token\":\"#{user.authentication_token}\"}}"}
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
      before {post :create, session: {email: user.email, password: "12345678"}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(response.body).to eql "{\"session\":{\"user_id\":#{user.reload.id},\"email\":\"#{user.email}\",\"authentication_token\":\"#{user.authentication_token}\"}}"}
    end

    describe "DELETE 'destroy'" do
      before {delete :destroy, format: 'json'}
      it {expect(response.status).to eql 202}
      it {expect(response.body).to eql "{}"}
    end
  end
end
