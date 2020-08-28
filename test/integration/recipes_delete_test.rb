require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @user = Chef.create!(chefname: 'lucas', email: 'lucas@gmail.com',
                         password: 'password', password_confirmation: 'password')
    @recipe = Recipe.create(name: 'french fries', description: 'crispy french fries', chef: @user)
  end

  test 'successfullly delete a recipe' do
    sign_in_as(@user, 'password')
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_select 'a[href=?]', recipe_path(@recipe), text: 'Delete this recipe'
    assert_difference 'Recipe.count', -1 do
      delete recipe_path(@recipe)
    end
    assert_redirected_to recipes_path
    assert_not flash.empty?
  end
end
