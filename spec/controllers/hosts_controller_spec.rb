require 'spec_helper'

describe HostsController do

  def valid_params
    attributes_for :host
  end

  def invalid_params
    valid_params.merge!(name: "")
  end

  context "as guest" do
    let!(:host) { create :host }
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:hosts).to_a).to eq [host]}
    end

    describe "GET 'show'" do
      before {get :show, id: host.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:host)).to eq host}
    end

    describe "POST 'create' with valid params" do
      before {post :create, host: valid_params, format: 'json'}
      should_not_be_authorized
    end

    describe "PATCH 'update'" do
      before {patch :create, id: host.to_param, host: {name: "new_name"}, format: 'json'}
      should_not_be_authorized
    end

    describe "DELETE 'destroy' with valid params" do
      before {delete :destroy, id: host.to_param, format: 'json'}
      should_not_be_authorized
    end
  end

  context "as member" do
    let!(:host) { create :host }
    let!(:member) {create :user}
    before {sign_in member}
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:hosts).to_a).to eq [host]}
    end

    describe "GET 'show'" do
      before {get :show, id: host.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:host)).to eq host}
    end

    describe "POST 'create' with valid params" do
      let!(:host_count){Host.count}
      before {post :create, host: valid_params, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:host)).to be_valid_verbose}
      it {expect(Host.count-host_count).to eq 1}
      it {expect(assigns(:host)).to be_a Host}
    end

    describe "POST 'create' with invalid params" do
      let!(:host_count){Host.count}
      before {post :create, host: invalid_params, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(Host.count-host_count).to eq 0}
      it {expect(assigns(:host)).to_not be_valid_verbose}
      it {expect(assigns(:host).errors[:name]).to eq ["can't be blank"]}
    end

    describe "PATCH 'update' with valid params" do
      let!(:host) { create :host }
      before {
        patch :update, id: host.to_param, host: {name: "new_name"}, format: 'json'
        host.reload
      }
      it {expect(response).to be_success}
      it {expect(assigns(:host)).to be_valid}
      it {expect(host.reload.name).to eq "new_name"}
    end

    describe "PATCH 'update' with invalid params" do
      before {patch :update, id: host.to_param, host: {name: ""}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(assigns(:host)).to_not be_valid_verbose}
      it {expect(assigns(:host).errors[:name]).to eq ["can't be blank"]}
    end

    describe "DELETE 'destroy'" do
      let!(:host_count){Host.count}
      before {delete :destroy, id: host.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Host.count-host_count).to eq -1}
    end
  end

  context "as admin" do
    let!(:host) { create :host }
    let!(:admin_user) {create :user, admin: true}
    before {
      sign_in(admin_user)
    }
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:hosts).to_a).to eq [host]}
    end

    describe "GET 'show'" do
      before {get :show, id: host.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:host)).to eq host}
    end

    describe "POST 'create' with valid params" do
      let!(:host_count){Host.count}
      before {post :create, host: attributes_for(:host), format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:host)).to be_valid_verbose}
      it {expect(Host.count-host_count).to eq 1}
      it {expect(assigns(:host)).to be_a Host}
    end

    describe "POST 'create' with invalid params" do
      let!(:host_count){Host.count}
      before {post :create, host: invalid_params, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(Host.count-host_count).to eq 0}
      it {expect(assigns(:host)).to_not be_valid_verbose}
      it {expect(assigns(:host).errors[:name]).to eq ["can't be blank"]}
    end

    describe "PATCH 'update' with valid params" do
      before {patch :update, id: host.to_param, host: {name: "new_name"}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:host)).to be_valid_verbose}
      it {expect(assigns(:host).name).to eq "new_name"}
    end

    describe "PATCH 'update' with invalid params" do
      before {patch :update, id: host.to_param, host: {name: ""}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(assigns(:host)).to_not be_valid_verbose}
      it {expect(assigns(:host).errors[:name]).to eq ["can't be blank"]}
    end

    describe "DELETE 'destroy'" do
      let!(:host_count){Host.count}
      before {delete :destroy, id: host.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Host.count-host_count).to eq -1}
    end

    describe "DELETE 'destroy' with bad id" do
      before {delete :destroy, id: rand(99999999), format: 'json'}
      it {expect(response.status).to eq 404}
      it {expect(response.body).to match /Couldn't find Host with 'id/}
    end
  end
end
