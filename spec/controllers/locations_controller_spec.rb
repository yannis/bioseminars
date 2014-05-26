require 'spec_helper'

describe LocationsController do

  def valid_params
    attributes_for :location, building_id: create(:building).id
  end

  def invalid_params
    valid_params.merge! name: ""
  end


  context "as guest" do
    let!(:location) { create :location }
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:locations).to_a).to eq [location]}
    end

    describe "GET 'show'" do
      before {get :show, id: location.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:location)).to eq location}
    end

    describe "POST 'create' with valid params" do
      before {post :create, location: valid_params, format: 'json'}
      should_not_be_authorized
    end

    describe "PATCH 'update'" do
      before {patch :create, id: location.to_param, location: {name: "new_name"}, format: 'json'}
      should_not_be_authorized
    end

    describe "DELETE 'destroy' with valid params" do
      before {delete :destroy, id: location.to_param, format: 'json'}
      should_not_be_authorized
    end
  end

  context "as member" do
    let!(:location) { create :location }
    let!(:member) {create :user}
    before {sign_in member}
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:locations).to_a).to eq [location]}
    end

    describe "GET 'show'" do
      before {get :show, id: location.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:location)).to eq location}
    end

    describe "POST 'create' with valid params" do
      let!(:location_count){Location.count}
      before {post :create, location: valid_params, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:location)).to be_valid_verbose}
      it {expect(Location.count-location_count).to eq 1}
      it {expect(assigns(:location)).to be_a Location}
    end

    describe "POST 'create' with invalid params" do
      let!(:location_count){Location.count}
      before {post :create, location: invalid_params, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(Location.count-location_count).to eq 0}
      it {expect(assigns(:location)).to_not be_valid_verbose}
      it {expect(assigns(:location).errors[:name]).to eq ["can't be blank"]}
    end

    describe "PATCH 'update' with valid params" do
      let!(:location) { create :location }
      before { patch :update, id: location.to_param, location: valid_params.merge(name: "new_name"), format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:location)).to be_valid}
      it {expect(location.reload.name).to eq "new_name"}
    end

    describe "PATCH 'update' with invalid params" do
      before {patch :update, id: location.to_param, location: invalid_params, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(assigns(:location)).to_not be_valid_verbose}
      it {expect(assigns(:location).errors[:name]).to eq ["can't be blank"]}
    end

    describe "DELETE 'destroy'" do
      let!(:location_count){Location.count}
      before {delete :destroy, id: location.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Location.count-location_count).to eq -1}
    end
  end

  context "as admin" do
    let!(:location) { create :location }
    let!(:admin_user) {create :user, admin: true}
    before {
      sign_in(admin_user)
    }
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:locations).to_a).to eq [location]}
    end

    describe "GET 'show'" do
      before {get :show, id: location.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:location)).to eq location}
    end

    describe "POST 'create' with valid params" do
      let!(:location_count){Location.count}
      before {post :create, location: valid_params, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:location)).to be_valid_verbose}
      it {expect(Location.count-location_count).to eq 1}
      it {expect(assigns(:location)).to be_a Location}
    end

    describe "POST 'create' with invalid params" do
      let!(:location_count){Location.count}
      before {post :create, location: invalid_params, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(Location.count-location_count).to eq 0}
      it {expect(assigns(:location)).to_not be_valid_verbose}
      it {expect(assigns(:location).errors[:name]).to eq ["can't be blank"]}
    end

    describe "PATCH 'update' with valid params" do
      before {patch :update, id: location.to_param, location: valid_params.merge(name: "new_name"), format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:location)).to be_valid_verbose}
      it {expect(assigns(:location).name).to eq "new_name"}
    end

    describe "PATCH 'update' with invalid params" do
      before {patch :update, id: location.to_param, location: invalid_params, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(assigns(:location)).to_not be_valid_verbose}
      it {expect(assigns(:location).errors[:name]).to eq ["can't be blank"]}
    end

    describe "DELETE 'destroy'" do
      let!(:location_count){Location.count}
      before {delete :destroy, id: location.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Location.count-location_count).to eq -1}
    end

    describe "DELETE 'destroy' with bad id" do
      before {delete :destroy, id: rand(99999999), format: 'json'}
      it {expect(response.status).to eq 404}
      it {expect(response.body).to match /Couldn't find Location with 'id/}
    end
  end
end
