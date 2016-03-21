class AddTimestampsToTimesheet < ActiveRecord::Migration
  def change
    add_column :timesheets, :created_at, :datetime
    add_column :timesheets, :updated_at, :datetime
  end
end
