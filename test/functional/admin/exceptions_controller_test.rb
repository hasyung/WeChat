require 'test_helper'

class Admin::ExceptionsControllerTest < ActionController::TestCase
  test "should get assets=false" do
    get :assets=false
    assert_response :success
  end

  test "should get helper=false" do
    get :helper=false
    assert_response :success
  end

end
