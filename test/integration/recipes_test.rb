require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  def setup
    @user = Chef.create!(chefname: 'lucas', email: 'lucas@gmail.com')
    @recipe = Recipe.create(name: 'french fries', description: 'crispy french fries', chef: @user)
    @user.save
  end

  test 'should get recipes index' do
    get recipes_url
    assert_response :success
  end
  
  test 'should get recipes listing' do
    get recipes_path
    assert_template 'recipes/index'
    assert_match @recipe.name, response.body
  end
end
