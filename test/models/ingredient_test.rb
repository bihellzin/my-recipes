require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  def setup
    @ingredient = Ingredient.new(name: 'egg')
  end

  test 'ingredient should be valid' do
    assert @ingredient.valid?
  end

  test 'ingredient must have name' do
    @ingredient.name = ''
    assert_not @ingredient.valid?
  end

  test 'ingredient name should have at least 3 characters' do
    @ingredient.name = 'a' * 2
    assert_not @ingredient.valid?
  end

  test 'ingredient name shouldnt have more than 25 characters' do
    @ingredient.name = 'a' * 26
    assert_not @ingredient.valid?
  end

  test 'ingredient name should be unique' do
    same = @ingredient.dup
    same.name = @ingredient.name.upcase
    @ingredient.save
    assert_not same.valid?
  end
end
