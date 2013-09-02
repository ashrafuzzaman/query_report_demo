class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end

    change_table :invoices do |t|
      t.integer :received_by_id
    end
    remove_column :invoices,  :received_by, :string
  end
end