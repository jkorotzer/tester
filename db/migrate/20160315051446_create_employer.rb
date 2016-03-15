class CreateEmployer < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      t.string :name
      t.string :password_digest 
      t.string :company_name
    end
  end
end
