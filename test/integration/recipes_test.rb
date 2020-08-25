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

  test 'should get recipes list' do
    get recipes_path
    assert_template 'recipes/index'
    assert_select 'a[href=?]', recipe_path(@recipe), text: @recipe.name
  end

  test 'should get recipe show' do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_match @recipe.name, response.body
    assert_match @recipe.description, response.body
    assert_match @user.chefname, response.body
    assert_select 'a[href=?]', edit_recipe_path(@recipe), text: 'Edit this recipe'
    assert_select 'a[href=?]', recipe_path(@recipe), text: 'Delete this recipe'
    assert_select 'a[href=?]', recipes_path, text: 'Return to recipe list'
  end

  test 'create a new valid recipe' do
    get new_recipe_path
    assert_template 'recipes/new'
    recipe_name = 'fried butter'
    recipe_description = 'very tasty american food'
    assert_difference 'Recipe.count', 1 do
      post recipes_path, params: { recipe: { name: recipe_name, description: recipe_description } }
    end
    follow_redirect!
    assert_match recipe_name.capitalize, response.body
    assert_match recipe_description, response.body
  end

  test 'reject invalid recipe submission' do
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: { recipe: { name: ' ', description: ' ' } }
    end
    assert_template 'recipes/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
