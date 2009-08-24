require 'test_helper'

class SeminarsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:seminars)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_seminar
    assert_difference('Seminar.count') do
      post :create, :seminar => { }
    end

    assert_redirected_to seminar_path(assigns(:seminar))
  end

  def test_should_show_seminar
    get :show, :id => seminars(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => seminars(:one).id
    assert_response :success
  end

  def test_should_update_seminar
    put :update, :id => seminars(:one).id, :seminar => { }
    assert_redirected_to seminar_path(assigns(:seminar))
  end

  def test_should_destroy_seminar
    assert_difference('Seminar.count', -1) do
      delete :destroy, :id => seminars(:one).id
    end

    assert_redirected_to seminars_path
  end
end
