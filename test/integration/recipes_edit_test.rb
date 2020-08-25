require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = Chef.create!(chefname: 'lucas', email: 'lucas@gmail.com')
    @recipe = Recipe.create(name: 'french fries', description: 'crispy french fries', chef: @user)
  end

  test 'reject invalid recipe update' do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe), params: { recipe: { name: '', description: 'something' } }
    assert_template 'recipes/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'successfully edit a recipe' do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    new_name = 'new recipe'
    new_description = 'new description'
    patch recipe_path(@recipe), params: { recipe: { name: new_name, description: new_description } }
    assert_redirected_to @recipe
    assert_not flash.empty?
    @recipe.reload
    assert_match new_name, @recipe.name
    assert_match new_description, @recipe.description
  end
end
