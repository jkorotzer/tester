class Timesheet < ActiveRecord::Base
  belongs_to :employer
  belongs_to :employee
end