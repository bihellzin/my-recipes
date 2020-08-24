require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @recipe = Recipe.new(name: 'fried chicken', description: 'very tasty fried chicken')
  end

  test 'recipe should be valid' do
    assert @recipe.valid?
  end

  test 'name should be present' do
    @recipe.name = ' '
    assert_not @recipe.valid?
  end

  test 'description should be present' do
    @recipe.description = ' '
    assert_not @recipe.valid?
  end

  test 'description shouldnt be less than 5 characters' do
    @recipe.description = 'a' * 3
    assert_not @recipe.valid?
  end

  test 'description shouldnt be more than 500 characters' do
    @recipe.description = 'a' * 501
    assert_not @recipe.valid?
  end
end
