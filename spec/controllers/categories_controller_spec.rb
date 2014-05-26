require 'spec_helper'
describe CategoriesController do
  def valid_params
    attributes_for :category
  end

  def invalid_params
    attributes_for(:category).merge!({name: ""})
  end

  context "as guest" do
    let!(:category) { create :category }

    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:categories).to_a).to eq [category]}
    end

    describe "GET 'show'" do
      before {get :show, id: category.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:category)).to eq category}
    end

    describe "POST 'create' with valid params" do
      before {post :create, category: valid_params, format: 'json'}
      should_not_be_authorized
    end

    describe "PATCH 'update'" do
      before {patch :create, id: category.to_param, category: {name: "new_name"}, format: 'json'}
      should_not_be_authorized
    end

    describe "DELETE 'destroy' with valid params" do
      before {delete :destroy, id: category.to_param, format: 'json'}
      should_not_be_authorized
    end
  end

  context "as member" do
    let!(:category) { create :category }
    let!(:member) {create :user}
    before {sign_in member}
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:categories).to_a).to eq [category]}
    end

    describe "GET 'show'" do
      before {get :show, id: category.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:category)).to eq category}
    end

    describe "POST 'create' with valid params" do
      before {post :create, category: valid_params, format: 'json'}
      should_not_be_authorized
    end

    describe "PATCH 'update'" do
      before {patch :create, id: category.to_param, category: {name: "new_name"}, format: 'json'}
      should_not_be_authorized
    end

    describe "DELETE 'destroy' with valid params" do
      before {delete :destroy, id: category.to_param, format: 'json'}
      should_not_be_authorized
    end

    # describe "POST 'create' with valid params" do
    #   let!(:category_count){Category.count}
    #   before {post :create, category: valid_params, format: 'json'}
    #   it {expect(response).to be_success}
    #   it {expect(assigns(:category)).to be_valid_verbose}
    #   it {expect(Category.count-category_count).to eq 1}
    #   it {expect(assigns(:category)).to be_a Category}
    # end

    # describe "POST 'create' with invalid params" do
    #   let!(:category_count){Category.count}
    #   before {post :create, category: invalid_params, format: 'json'}
    #   it {expect(response.status).to eq 422}
    #   it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
    #   it {expect(Category.count-category_count).to eq 0}
    #   it {expect(assigns(:category)).to_not be_valid_verbose}
    #   it {expect(assigns(:category).errors[:name]).to eq ["can't be blank"]}
    # end

    # describe "PATCH 'update' with valid params" do
    #   let!(:category) { create :category }
    #   before {
    #     patch :update, id: category.to_param, category: {name: "new_name"}, format: 'json'
    #     category.reload
    #   }
    #   it {expect(response).to be_success}
    #   it {expect(assigns(:category)).to be_valid}
    #   it {expect(category.reload.name).to eq "new_name"}
    # end

    # describe "PATCH 'update' with invalid params" do
    #   before {patch :update, id: category.to_param, category: {name: ""}, format: 'json'}
    #   it {expect(response.status).to eq 422}
    #   it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
    #   it {expect(assigns(:category)).to_not be_valid_verbose}
    #   it {expect(assigns(:category).errors[:name]).to eq ["can't be blank"]}
    # end

    # describe "DELETE 'destroy'" do
    #   let!(:category_count){Category.count}
    #   before {delete :destroy, id: category.to_param, format: 'json'}
    #   it {expect(response).to be_success}
    #   it {expect(Category.count-category_count).to eq -1}
    # end
  end

  context "as admin" do
    let!(:category) { create :category }
    let!(:admin_user) {create :user, admin: true}
    before {
      sign_in(admin_user)
    }
    describe "GET 'index'" do
      before {get :index, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:categories).to_a).to eq [category]}
    end

    describe "GET 'show'" do
      before {get :show, id: category.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:category)).to eq category}
    end

    describe "POST 'create' with valid params" do
      let!(:category_count){Category.count}
      before {post :create, category: valid_params, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:category)).to be_valid_verbose}
      it {expect(Category.count-category_count).to eq 1}
      it {expect(assigns(:category)).to be_a Category}
    end

    describe "POST 'create' with invalid params" do
      let!(:category_count){Category.count}
      before {post :create, category: attributes_for(:category).merge!({name: ""}), format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(Category.count-category_count).to eq 0}
      it {expect(assigns(:category)).to_not be_valid_verbose}
      it {expect(assigns(:category).errors[:name]).to eq ["can't be blank"]}
    end

    describe "PATCH 'update' with valid params" do
      before {patch :update, id: category.to_param, category: {name: "new_name"}, format: 'json'}
      it {expect(response).to be_success}
      it {expect(assigns(:category)).to be_valid_verbose}
      it {expect(assigns(:category).name).to eq "new_name"}
    end

    describe "PATCH 'update' with invalid params" do
      before {patch :update, id: category.to_param, category: {name: ""}, format: 'json'}
      it {expect(response.status).to eq 422}
      it {expect(response.body).to eq "{\"errors\":{\"name\":[\"can't be blank\"]}}"}
      it {expect(assigns(:category)).to_not be_valid_verbose}
      it {expect(assigns(:category).errors[:name]).to eq ["can't be blank"]}
    end

    describe "DELETE 'destroy'" do
      let!(:category_count){Category.count}
      before {delete :destroy, id: category.to_param, format: 'json'}
      it {expect(response).to be_success}
      it {expect(Category.count-category_count).to eq -1}
    end

    describe "DELETE 'destroy' with bad id" do
      before {delete :destroy, id: rand(99999999), format: 'json'}
      it {expect(response.status).to eq 404}
      it {expect(response.body).to match /Couldn't find Category with 'id/}
    end
  end
end
