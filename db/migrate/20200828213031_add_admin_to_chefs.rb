class AddAdminToChefs < ActiveRecord::Migration[6.0]
  def change
    add_column :chefs, :admin, :boolean, default: false
  end
end
