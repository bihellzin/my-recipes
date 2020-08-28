require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.new(chefname: 'gabriel', email: 'example@test.com',
                     password: 'password', password_confirmation: 'password')
  end

  test 'should be valid' do
    assert @chef.valid?
  end

  test 'chefname should be present' do
    @chef.chefname = ''
    assert_not @chef.valid?
  end

  test 'chefname should be less than 30 characters' do
    @chef.chefname = 'a' * 31
    assert_not @chef.valid?
  end

  test 'email should be present' do
    @chef.email = ''
    assert_not @chef.valid?
  end

  test 'email shouldnt be too long' do
    @chef.email = 'a' * 245 + '@example.com'
    assert_not @chef.valid?
  end

  test 'email should have correct format' do
    valid_emails = %w[user@example.com IDK@gmail.com M.anything@yahoo.ca i+dont+care@co.uk.org]
    valid_emails.each do |valids|
      @chef.email = valids
      assert @chef.valid?, "#{valids.inspect} should be valid"
    end
  end

  test 'invalid emails should be rejected' do
    invalid_emails = %w[idk@example test@example,com try@some+thing.com john.foo@doe.]
    invalid_emails.each do |invalid|
      @chef.email = invalid
      assert_not @chef.valid?, "#{invalid.inspect} should be invalid"
    end
  end

  test 'email should be unique and case insensitive' do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test 'email should be lowercase before hitting db' do
    mixed_email = 'JoHn@DoE.COM'
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end

  test 'password should be present' do
    @chef.password = @chef.password_confirmation = ' '
    assert_not @chef.valid?
  end

  test 'password should be at least 8 characters' do
    @chef.password = @chef.password_confirmation = 'a' * 7
    assert_not @chef.valid?
  end

  test 'recipes should be deleted' do
    @chef.save
    @chef.recipes.create!(name: 'test', description: 'teste ')
    assert_difference 'Recipe.count', -1 do
      @chef.destroy
    end
  end
end
