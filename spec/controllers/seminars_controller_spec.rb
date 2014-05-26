require 'spec_helper'

describe SeminarsController do

  def valid_params
    # attributes_for :seminar, hostings: [{host_id: create(:host).id}], categorisations: [{category_id: create(:category).id}], location_id: create(:location).id
    {title: "valid seminar title", speaker_name: "a speaker name", speaker_affiliation: "a speaker affiliation", start_at: 2.weeks.since, hostings: [{host_id: create(:host).id}], categorisations: [{category_id: create(:category).id}], location_id: create(:location).id }
  end

  def invalid_params
    valid_params.merge! title: ""
  end


  context "as guest" do
    let!(:seminar) { create :seminar }
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:seminars).to_a).to eq [seminar]}
    end

    describe "GET 'show'" do
      before {get :show, id: seminar.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:seminar)).to eq seminar}
    end

    describe "POST 'create' with valid params" do
      before {post :create, seminar: valid_params, format: 'json'}
      should_not_be_authorized
    end

    describe "PATCH 'update'" do
      before {patch :create, id: seminar.to_param, seminar: {title: "new_title"}, format: 'json'}
      should_not_be_authorized
    end

    describe "DELETE 'destroy' with valid params" do
      before {delete :destroy, id: seminar.to_param, format: 'json'}
      should_not_be_authorized
    end
  end

  context "as member" do
    let!(:seminar) { create :seminar }
    let!(:member) {create :user}
    before {sign_in member}
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:seminars).to_a).to eq [seminar]}
    end

    describe "GET 'show'" do
      before {get :show, id: seminar.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:seminar)).to eq seminar}
    end

    describe "POST 'create' with valid params" do
      let!(:seminar_count){Seminar.count}
      before {post :create, seminar: valid_params, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:seminar)).to be_valid_verbose}
      it {expect(Seminar.count-seminar_count).to eq 1}
      it {expect(assigns(:seminar)).to be_a Seminar}
    end

    describe "POST 'create' with invalid params" do
      let!(:seminar_count){Seminar.count}
      before {post :create, seminar: invalid_params, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"title\":[\"can't be blank\"]}}"}
      it {expect(Seminar.count-seminar_count).to eq 0}
      it {expect(assigns(:seminar)).to_not be_valid_verbose}
      it {expect(assigns(:seminar).errors[:title]).to eq ["can't be blank"]}
    end

    describe "PATCH 'update' a seminar own by user with valid params" do
      let!(:seminar_member) { create :seminar, user: member }
      before { patch :update, id: seminar_member.to_param, seminar: {title: "new_title"}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:seminar)).to be_valid}
      it {expect(seminar_member.reload.title).to eq "new_title"}
    end

    describe "PATCH 'update' a seminar own by user with invalid params" do
      let!(:seminar_member) { create :seminar, user: member }
      before { patch :update, id: seminar_member.to_param, seminar: {title: nil}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"title\":[\"can't be blank\"]}}"}
      it {expect(assigns(:seminar)).to_not be_valid_verbose}
      it {expect(assigns(:seminar).errors[:title]).to eq ["can't be blank"]}
    end

    describe "PATCH 'update' a seminar not own by user with valid params"  do
      before { patch :update, id: seminar.to_param, seminar: {title: "new_title"}, format: 'json'}
    end

    describe "DELETE 'destroy' a seminar own by user" do
      let!(:seminar_member) { create :seminar, user: member }
      let!(:seminar_count){Seminar.count}
      before {delete :destroy, id: seminar_member.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Seminar.count-seminar_count).to eq -1}
    end

    describe "DELETE 'destroy' a seminar not own by user" do
      before {delete :destroy, id: seminar.to_param, format: 'json'}
      should_not_be_authorized
    end
  end

  context "as admin" do
    let!(:seminar) { create :seminar }
    let!(:admin) {create :user, admin: true}

    before {sign_in admin}

    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:seminars).to_a).to eq [seminar]}
    end

    describe "GET 'show'" do
      before {get :show, id: seminar.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:seminar)).to eq seminar}
    end

    describe "POST 'create' with valid params" do
      let!(:seminar_count){Seminar.count}
      before {post :create, seminar: valid_params, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:seminar)).to be_valid_verbose}
      it {expect(Seminar.count-seminar_count).to eq 1}
      it {expect(assigns(:seminar)).to be_a Seminar}
    end

    describe "POST 'create' with invalid params" do
      let!(:seminar_count){Seminar.count}
      before {post :create, seminar: invalid_params, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"title\":[\"can't be blank\"]}}"}
      it {expect(Seminar.count-seminar_count).to eq 0}
      it {expect(assigns(:seminar)).to_not be_valid_verbose}
      it {expect(assigns(:seminar).errors[:title]).to eq ["can't be blank"]}
    end

    describe "PATCH 'update' a seminar own by user with valid params" do
      let!(:seminar_admin) { create :seminar, user: admin }
      before { patch :update, id: seminar_admin.to_param, seminar: {title: "new_title"}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:seminar)).to be_valid}
      it {expect(seminar_admin.reload.title).to eq "new_title"}
    end

    describe "PATCH 'update' a seminar own by user with invalid params" do
      let!(:seminar_admin) { create :seminar, user: admin }
      before { patch :update, id: seminar_admin.to_param, seminar: {title: ""}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"title\":[\"can't be blank\"]}}"}
      it {expect(assigns(:seminar)).to_not be_valid_verbose}
      it {expect(assigns(:seminar).errors[:title]).to eq ["can't be blank"]}
    end

    describe "PATCH 'update' a seminar not own by user with valid params"  do
      before { patch :update, id: seminar.to_param, seminar: {title: "new_title"}, format: 'json'}
    end

    describe "DELETE 'destroy' a seminar own by user" do
      let!(:seminar_admin) { create :seminar, user: admin }
      let!(:seminar_count){Seminar.count}
      before {delete :destroy, id: seminar_admin.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Seminar.count-seminar_count).to eq -1}
    end

    describe "DELETE 'destroy' a seminar not own by user" do
      let!(:seminar) { create :seminar, user: admin }
      let!(:seminar_count){Seminar.count}
      before {delete :destroy, id: seminar.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Seminar.count-seminar_count).to eq -1}
    end
  end
end
