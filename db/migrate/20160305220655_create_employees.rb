class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.integer :employer_id
      t.string :name
      t.string :password_digest
    end
  end
end
