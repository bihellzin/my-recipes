class CreateChefs < ActiveRecord::Migration[6.0]
  def change
    create_table :chefs do |t|
      t.string :chefname
      t.string :email
      t.timestamps
    end
  end
end
