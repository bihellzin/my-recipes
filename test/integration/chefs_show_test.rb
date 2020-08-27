require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: 'lucas', email: 'lucas@gmail.com',
                         password: 'password', password_confirmation: 'password')
    @recipe = Recipe.create(name: 'french fries', description: 'crispy french fries', chef: @chef)
    @chef.save
  end

  test 'should get chefs show' do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_match @chef.chefname, response.body
    assert_select 'a[href=?]', recipe_path(@recipe), text: @recipe.name
    assert_match @recipe.description, response.body
  end
end
