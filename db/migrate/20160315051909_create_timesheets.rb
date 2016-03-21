class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.integer :employer_id
      t.integer :employee_id
      t.boolean :in
    end
  end
end
