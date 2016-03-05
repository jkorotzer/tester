class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :address
    end
  end
end
