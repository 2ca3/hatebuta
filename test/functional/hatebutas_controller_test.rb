require 'test_helper'

class HatebutasControllerTest < ActionController::TestCase
#  test "should get index" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:hatebutas)
#  end
#
#  test "should get new" do
#    get :new
#    assert_response :success
#  end
#
#  test "should create hatebuta" do
#    assert_difference('Hatebuta.count') do
#      post :create, :hatebuta => { }
#    end
#
#    assert_redirected_to hatebuta_path(assigns(:hatebuta))
#  end
#
#  test "should show hatebuta" do
#    get :show, :id => hatebutas(:one).to_param
#    assert_response :success
#  end
#
#  test "should get edit" do
#    get :edit, :id => hatebutas(:one).to_param
#    assert_response :success
#  end
#
#  test "should update hatebuta" do
#    put :update, :id => hatebutas(:one).to_param, :hatebuta => { }
#    assert_redirected_to hatebuta_path(assigns(:hatebuta))
#  end
#
#  test "should destroy hatebuta" do
#    assert_difference('Hatebuta.count', -1) do
#      delete :destroy, :id => hatebutas(:one).to_param
#    end
#
#    assert_redirected_to hatebutas_path
#  end

  def test_create_action
    get :create , :hatebuta => {
       :timeline_key => '4b5597fa92ad617a325545e0dd63640a',
       :title => 'test_title',
       :description => 'test_description',
       :open_level => 1 
     }
     assert_response :redirect
     #assert_redirected_to :controller => 'hatebutas', :action => 'index'
  end

  def test_hook_action
     hatebuta1 = Hatebuta.find(:first)
     post :hook , :hatebuta => {
       :username => 'test_username',
       :title => 'test_title',
       :url => 'test_url',
       :count => '123',
       :status => 'favorite:add',
       :comment => 'test_ƒRƒƒ“ƒg',
       :is_private => '0',
       :timestamp => Time.now,
       :key => hatebuta1.hatebuta_key 
#       :key => 'ab9d61168a8ce9c8269ea6258d3eee70' 
     }
     assert_response :redirect
#     #assert_redirected_to :controller => 'hatebutas', :action => 'index' 
  end

end
