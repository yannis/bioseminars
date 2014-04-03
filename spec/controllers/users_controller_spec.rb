require 'spec_helper'

def valid_params
  attributes_for :user
end

def invalid_params
  attributes_for(:user).merge!({name: ""})
end

describe UsersController do

  context "as guest" do
    let!(:user) { create :user }
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      should_not_be_authorized
    end

    describe "GET 'show'" do
      before {get :show, id: user.to_param, format: 'json'}
      should_not_be_authorized
    end

    describe "POST 'create' with valid params" do
      before {post :create, user: valid_params, format: 'json'}
      should_not_be_authorized
    end

    describe "PATCH 'update'" do
      before {patch :create, id: user.to_param, user: {name: "new_name"}, format: 'json'}
      should_not_be_authorized
    end

    describe "DELETE 'destroy' with valid params" do
      before {delete :destroy, id: user.to_param, format: 'json'}
      should_not_be_authorized
    end
  end

  context "as member" do
    let!(:user) { create :user }
    let!(:member) {create :user}
    before {sign_in member}
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      should_not_be_authorized
    end

    describe "GET 'show' with invalid id" do
      before {get :show, id: user.to_param, format: 'json'}
      should_not_be_authorized
    end

    describe "GET 'show' with valid id" do
      before {get :show, id: member.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:user)).to eq member}
    end

    describe "POST 'create' with valid params" do
      let!(:user_count){User.count}
      before {post :create, user: valid_params, format: 'json'}
      should_not_be_authorized
    end

    describe "POST 'create' with invalid params" do
      let!(:user_count){User.count}
      before {post :create, user: invalid_params, format: 'json'}
      should_not_be_authorized
    end

    describe "PATCH 'update' with valid params and valid id" do
      before {patch :update, id: member.to_param, user: {name: "new_name"}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:user)).to eq member}
      it {expect(assigns(:user).name).to eq "new_name"}
    end

    describe "PATCH 'update' with valid params but invalid id" do
      before {patch :update, id: user.to_param, user: {name: "new_name"}, format: 'json'}
      should_not_be_authorized
    end

    describe "PATCH 'update' with valid id but invalid params" do
      before {patch :update, id: member.to_param, user: {name: ""}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(assigns(:user)).to_not be_valid_verbose}
      it {expect(assigns(:user).errors[:name]).to eq ["can't be blank"]}
    end

    describe "DELETE 'destroy'" do
      let!(:user_count){User.count}
      before {delete :destroy, id: user.to_param, format: 'json'}
      should_not_be_authorized
    end
  end

  context "as admin" do
    let!(:user) { create :user }
    let(:admin) {create :user, admin: true}
    before {
      sign_in(admin)
    }
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:users).to_a).to eq [user, admin]}
    end

    describe "GET 'show'" do
      before {get :show, id: user.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:user)).to eq user}
    end

    describe "POST 'create' with valid params" do
      let!(:user_count){User.count}
      before {post :create, user: valid_params, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:user)).to be_valid_verbose}
      it {expect(User.count-user_count).to eq 1}
      it {expect(assigns(:user)).to be_a User}
    end

    describe "POST 'create' with invalid params" do
      let!(:user_count){User.count}
      before {post :create, user: invalid_params, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(User.count-user_count).to eq 0}
      it {expect(assigns(:user)).to_not be_valid_verbose}
      it {expect(assigns(:user).errors[:name]).to eq ["can't be blank"]}
    end

    describe "PATCH 'update' with valid params" do
      before {patch :update, id: user.to_param, user: {name: "new_name"}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:user)).to be_valid_verbose}
      it {expect(assigns(:user).name).to eq "new_name"}
    end

    describe "PATCH 'update' with invalid params" do
      before {patch :update, id: user.to_param, user: {name: ""}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(assigns(:user)).to_not be_valid_verbose}
      it {expect(assigns(:user).errors[:name]).to eq ["can't be blank"]}
    end

    describe "DELETE 'destroy'" do
      let!(:user_count){User.count}
      before {delete :destroy, id: user.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(User.count-user_count).to eq -1}
    end

    describe "DELETE 'destroy' with bad id" do
      before {delete :destroy, id: rand(99999999), format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to match /Couldn't find User with 'id/}
    end
  end
end
