require 'spec_helper'

def valid_params
  attributes_for :building
end

def invalid_params
  {name: ""}
end

describe BuildingsController do

  context "as guest" do
    let!(:building) { create :building }
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:buildings).to_a).to eq [building]}
    end

    describe "GET 'show'" do
      before {get :show, id: building.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:building)).to eq building}
    end

    describe "POST 'create' with valid params" do
      before {post :create, building: valid_params, format: 'json'}
      should_not_be_authorized
    end

    describe "PATCH 'update'" do
      before {patch :create, id: building.to_param, building: {name: "new_name"}, format: 'json'}
      should_not_be_authorized
    end

    describe "DELETE 'destroy' with valid params" do
      before {delete :destroy, id: building.to_param, format: 'json'}
      should_not_be_authorized
    end
  end

  context "as member" do
    let!(:building) { create :building }
    let!(:member) {create :user}
    before {sign_in member}
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:buildings).to_a).to eq [building]}
    end

    describe "GET 'show'" do
      before {get :show, id: building.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:building)).to eq building}
    end

    describe "POST 'create' with valid params" do
      let!(:building_count){Building.count}
      before {post :create, building: valid_params, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:building)).to be_valid_verbose}
      it {expect(Building.count-building_count).to eq 1}
      it {expect(assigns(:building)).to be_a Building}
    end

    describe "POST 'create' with invalid params" do
      let!(:building_count){Building.count}
      before {post :create, building: invalid_params, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"message\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(Building.count-building_count).to eq 0}
      it {expect(assigns(:building)).to_not be_valid_verbose}
      it {expect(assigns(:building).errors[:name]).to eq ["can't be blank"]}
    end

    describe "PATCH 'update' with valid params" do
      let!(:building) { create :building }
      before {
        patch :update, id: building.to_param, building: {name: "new_name"}, format: 'json'
        building.reload
      }
      it {expect(response).to be_success}
      it {expect(assigns(:building)).to be_valid}
      it {expect(building.reload.name).to eq "new_name"}
    end

    describe "PATCH 'update' with invalid params" do
      before {patch :update, id: building.to_param, building: {name: ""}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"message\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(assigns(:building)).to_not be_valid_verbose}
      it {expect(assigns(:building).errors[:name]).to eq ["can't be blank"]}
    end

    describe "DELETE 'destroy'" do
      let!(:building_count){Building.count}
      before {delete :destroy, id: building.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Building.count-building_count).to eq -1}
    end
  end

  context "as admin" do
    let!(:building) { create :building }
    let!(:admin_user) {create :user, admin: true}
    before {
      sign_in(admin_user)
    }
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:buildings).to_a).to eq [building]}
    end

    describe "GET 'show'" do
      before {get :show, id: building.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:building)).to eq building}
    end

    describe "POST 'create' with valid params" do
      let!(:building_count){Building.count}
      before {post :create, building: attributes_for(:building), format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:building)).to be_valid_verbose}
      it {expect(Building.count-building_count).to eq 1}
      it {expect(assigns(:building)).to be_a Building}
    end

    describe "POST 'create' with invalid params" do
      let!(:building_count){Building.count}
      before {post :create, building: {name: ""}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"message\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(Building.count-building_count).to eq 0}
      it {expect(assigns(:building)).to_not be_valid_verbose}
      it {expect(assigns(:building).errors[:name]).to eq ["can't be blank"]}
    end

    describe "PATCH 'update' with valid params" do
      before {patch :update, id: building.to_param, building: {name: "new_name"}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:building)).to be_valid_verbose}
      it {expect(assigns(:building).name).to eq "new_name"}
    end

    describe "PATCH 'update' with invalid params" do
      before {patch :update, id: building.to_param, building: {name: ""}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"message\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(assigns(:building)).to_not be_valid_verbose}
      it {expect(assigns(:building).errors[:name]).to eq ["can't be blank"]}
    end

    describe "DELETE 'destroy'" do
      let!(:building_count){Building.count}
      before {delete :destroy, id: building.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Building.count-building_count).to eq -1}
    end

    describe "DELETE 'destroy' with bad id" do
      before {delete :destroy, id: rand(99999999), format: 'json'}
      it {expect(response.status).to eq 404}
      it {expect(response.body).to match /Couldn't find Building with 'id/}
    end
  end
end
