require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: 'lucas', email: 'lucas@gmail.com',
                         password: 'password', password_confirmation: 'password')
    
    @admin_user = Chef.create!(chefname: 'john', email: 'john1@example.com', password: 'password',
                               password_confirmation: 'password', admin: true)
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

  test 'accept valid edit' do
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

  test 'accept edit attempt by admin user' do
    sign_in_as(@admin_user, 'password')
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path, params: { chef: { chefname: 'daledale1', email: 'novo1@email.com' } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match 'daledale1', @chef.chefname, response.body
    assert_match 'novo1@email.com', @chef.email, response.body
  end

  test 'redirect edit attempt by another non-admin user' do
    sign_in_as(@chef, 'password')
    patch chef_path(@admin_user), params: { chef: { chefname: 'daledale2', email: 'novo2@email.com' } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match 'lucas', @chef.chefname, response.body
    assert_match 'lucas@gmail.com', @chef.email, response.body
  end
end
