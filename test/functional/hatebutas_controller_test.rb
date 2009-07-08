require 'test_helper'

class HatebutasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hatebutas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hatebuta" do
    assert_difference('Hatebuta.count') do
      post :create, :hatebuta => { }
    end

    assert_redirected_to hatebuta_path(assigns(:hatebuta))
  end

  test "should show hatebuta" do
    get :show, :id => hatebutas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => hatebutas(:one).to_param
    assert_response :success
  end

  test "should update hatebuta" do
    put :update, :id => hatebutas(:one).to_param, :hatebuta => { }
    assert_redirected_to hatebuta_path(assigns(:hatebuta))
  end

  test "should destroy hatebuta" do
    assert_difference('Hatebuta.count', -1) do
      delete :destroy, :id => hatebutas(:one).to_param
    end

    assert_redirected_to hatebutas_path
  end
end
