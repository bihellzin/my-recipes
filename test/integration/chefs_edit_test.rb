require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: 'lucas', email: 'lucas@gmail.com',
                         password: 'password', password_confirmation: 'password')
  end

  test 'reject an invalid update' do
    sign_in_as(@chef, 'password')
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path, params: { chef: { chefname: '', email: '' } }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'accept valid update' do
    sign_in_as(@chef, 'password')
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path, params: { chef: { chefname: 'daledale', email: 'novo@email.com' } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match 'daledale', @chef.chefname, response.body
    assert_match 'novo@email.com', @chef.email, response.body
  end
end
