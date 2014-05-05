require 'spec_helper'
describe HostingsController do

  def valid_params
    {host_id: create(:host).id, seminar_id: create(:seminar).id}
  end

  context "as guest" do
    let!(:hosting) { create :hosting }
    let(:host) { create :host }
    let(:seminar) { create :seminar }

    describe "POST 'create' with valid params" do
      before {post :create, hosting: valid_params, format: 'json'}
      should_not_be_authorized
    end

    describe "PATCH 'update'" do
      before {patch :create, id: hosting.to_param, hosting: valid_params, format: 'json'}
      should_not_be_authorized
    end

    describe "DELETE 'destroy' with valid params" do
      before {delete :destroy, id: hosting.to_param, format: 'json'}
      should_not_be_authorized
    end
  end

  context "as member" do

    let!(:member) {create :user}
    let(:host) { create :host }
    let(:seminar) { create :seminar, user: member}
    let!(:hosting) { create :hosting, seminar_id: seminar.id }

    before {sign_in member}

    describe "POST 'create' with valid params" do
      let!(:hosting_count){Hosting.count}
      before {post :create, hosting: {seminar_id: seminar.id, host_id: host.id}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:hosting)).to be_valid_verbose}
      it {expect(Hosting.count-hosting_count).to eq 1}
      it {expect(assigns(:hosting)).to be_a Hosting}
    end

    describe "PATCH 'update' with seminar own by user with valid params" do
      let(:host) { create :host }
      before {
        patch :update, id: hosting.to_param, hosting: {host_id: create(:host).id}, format: 'json'
        hosting.reload
      }
      it {expect(response).to be_success}
      it {expect(assigns(:hosting)).to be_valid}
    end

    describe "PATCH 'update' with invalid params" do
      before {patch :update, id: hosting.to_param, hosting: {seminar_id: nil}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"message\":{\"seminar_id\":[\"can't be blank\"]}}"}
      it {expect(assigns(:hosting)).to_not be_valid_verbose}
      it {expect(assigns(:hosting).errors[:seminar_id]).to eq ["can't be blank"]}
    end

    describe "DELETE 'destroy'" do
      let!(:hosting_count){Hosting.count}
      before {delete :destroy, id: hosting.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Hosting.count-hosting_count).to eq -1}
    end
  end

  context "as admin" do
    let!(:admin_user) {create :user, admin: true}
    let(:host) { create :host }
    let(:seminar) { create :seminar, user: admin_user}
    let!(:hosting) { create :hosting, seminar_id: seminar.id }
    before {
      sign_in(admin_user)
    }

    it {expect(hosting).to be_valid_verbose}

    describe "POST 'create' with valid params" do
      let!(:hosting_count){Hosting.count}
      before {post :create, hosting: {host_id: host.id, seminar_id: seminar.id}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:hosting)).to be_valid_verbose}
      it {expect(Hosting.count-hosting_count).to eq 1}
      it {expect(assigns(:hosting)).to be_a Hosting}
    end

    describe "PATCH 'update' with valid params" do
      before {patch :update, id: hosting.to_param, hosting: {host_id: host.id}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:hosting)).to be_valid_verbose}
      it {expect(assigns(:hosting).host_id).to eq host.id}
    end

    describe "PATCH 'update' with invalid params" do
      before {patch :update, id: hosting.to_param, hosting: {host_id: nil}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"message\":{\"host_id\":[\"can't be blank\"]}}"}
      it {expect(assigns(:hosting)).to_not be_valid_verbose}
      it {expect(assigns(:hosting).errors[:host_id]).to eq ["can't be blank"]}
    end

    describe "DELETE 'destroy'" do
      let!(:hosting_count){Hosting.count}
      before {delete :destroy, id: hosting.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Hosting.count-hosting_count).to eq -1}
    end

    describe "DELETE 'destroy' with bad id" do
      before {delete :destroy, id: rand(99999999), format: 'json'}
      it {expect(response.status).to eq 404}
      it {expect(response.body).to match /Couldn't find Hosting with 'id/}
    end
  end
end
