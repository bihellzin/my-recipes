require 'test_helper'

class ChefsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: 'test', email: 'a@a.com', password: 'asdfasdf',
                         password_confirmation: 'asdfasdf')
  end

  test 'should get index page' do
    get chefs_path
    assert_template 'chefs/index'
    assert_match @chef.chefname, response.body
    assert_select 'a[href=?]', chef_path(@chef)
  end

  test 'should delete chef' do
    sign_in_as(@chef, 'asdfasdf')
    get chefs_path
    assert_template 'chefs/index'
    assert_difference 'Chef.count', -1 do
      delete chef_path(@chef)
    end
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
end
