class Employee < ActiveRecord::Base
  has_secure_password
  belongs_to :employer
  has_many :timesheets
end