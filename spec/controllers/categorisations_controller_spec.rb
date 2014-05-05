require 'spec_helper'


describe CategorisationsController do

  def valid_params
    {category_id: create(:category).id, seminar_id: create(:seminar).id}
  end

  context "as guest" do
    let!(:categorisation) { create :categorisation }
    let(:category) { create :category }
    let(:seminar) { create :seminar }

    describe "POST 'create' with valid params" do
      before {post :create, categorisation: valid_params, format: 'json'}
      should_not_be_authorized
    end

    describe "PATCH 'update'" do
      before {patch :create, id: categorisation.to_param, categorisation: valid_params, format: 'json'}
      should_not_be_authorized
    end

    describe "DELETE 'destroy' with valid params" do
      before {delete :destroy, id: categorisation.to_param, format: 'json'}
      should_not_be_authorized
    end
  end

  context "as member" do

    let!(:member) {create :user}
    let(:category) { create :category }
    let(:seminar) { create :seminar, user: member}
    let!(:categorisation) { create :categorisation, seminar_id: seminar.id }

    before {sign_in member}

    describe "POST 'create' with valid params" do
      let!(:categorisation_count){Categorisation.count}
      before {post :create, categorisation: {seminar_id: seminar.id, category_id: category.id}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:categorisation)).to be_valid_verbose}
      it {expect(Categorisation.count-categorisation_count).to eq 1}
      it {expect(assigns(:categorisation)).to be_a Categorisation}
    end

    describe "PATCH 'update' with seminar own by user with valid params" do
      let(:category) { create :category }
      before {
        patch :update, id: categorisation.to_param, categorisation: {category_id: create(:category).id}, format: 'json'
        categorisation.reload
      }
      it {expect(response).to be_success}
      it {expect(assigns(:categorisation)).to be_valid}
    end

    describe "PATCH 'update' with invalid params" do
      before {patch :update, id: categorisation.to_param, categorisation: {seminar_id: nil}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"message\":{\"seminar_id\":[\"can't be blank\"]}}"}
      it {expect(assigns(:categorisation)).to_not be_valid_verbose}
      it {expect(assigns(:categorisation).errors[:seminar_id]).to eq ["can't be blank"]}
    end

    describe "DELETE 'destroy'" do
      let!(:categorisation_count){Categorisation.count}
      before {delete :destroy, id: categorisation.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Categorisation.count-categorisation_count).to eq -1}
    end
  end

  context "as admin" do
    let!(:admin_user) {create :user, admin: true}
    let(:category) { create :category }
    let(:seminar) { create :seminar, user: admin_user}
    let!(:categorisation) { create :categorisation, seminar_id: seminar.id }
    before {
      sign_in(admin_user)
    }

    it {expect(categorisation).to be_valid_verbose}

    describe "POST 'create' with valid params" do
      let!(:categorisation_count){Categorisation.count}
      before {post :create, categorisation: {category_id: category.id, seminar_id: seminar.id}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:categorisation)).to be_valid_verbose}
      it {expect(Categorisation.count-categorisation_count).to eq 1}
      it {expect(assigns(:categorisation)).to be_a Categorisation}
    end

    describe "PATCH 'update' with valid params" do
      before {patch :update, id: categorisation.to_param, categorisation: {category_id: category.id}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:categorisation)).to be_valid_verbose}
      it {expect(assigns(:categorisation).category_id).to eq category.id}
    end

    describe "PATCH 'update' with invalid params" do
      before {patch :update, id: categorisation.to_param, categorisation: {category_id: nil}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"message\":{\"category_id\":[\"can't be blank\"]}}"}
      it {expect(assigns(:categorisation)).to_not be_valid_verbose}
      it {expect(assigns(:categorisation).errors[:category_id]).to eq ["can't be blank"]}
    end

    describe "DELETE 'destroy'" do
      let!(:categorisation_count){Categorisation.count}
      before {delete :destroy, id: categorisation.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Categorisation.count-categorisation_count).to eq -1}
    end

    describe "DELETE 'destroy' with bad id" do
      before {delete :destroy, id: rand(99999999), format: 'json'}
      it {expect(response.status).to eq 404}
      it {expect(response.body).to match /Couldn't find Categorisation with 'id/}
    end
  end
end
