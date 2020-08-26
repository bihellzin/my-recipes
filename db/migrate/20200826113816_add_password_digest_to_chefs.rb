class AddPasswordDigestToChefs < ActiveRecord::Migration[6.0]
  def change
    add_column :chefs, :password_digest, :string
  end
end
