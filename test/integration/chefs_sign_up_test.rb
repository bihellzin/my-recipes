require 'test_helper'

class ChefsSignUpTest < ActionDispatch::IntegrationTest
  test 'should get sign up path' do
    get signup_path
    assert_response :success
  end

  test 'reject an invalid signup' do
    get signup_path
    assert_no_difference 'Chef.count' do
      post chefs_path, params: { chef: { chefname: '', email: '',
                                         password: 'passworddale', password_confirmation: ' ' } }
    end
    assert_template 'chefs/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'accept valid signup' do
    get signup_path
    assert_difference 'Chef.count', 1 do
      post chefs_path, params: { chef: { chefname: 'galeroso', email: 'a@a.com',
                                         password: 'passworddale',
                                         password_confirmation: 'passworddale' } }
    end
    follow_redirect!
    assert_template 'chefs/show'
    assert_not flash.empty?
  end
end
