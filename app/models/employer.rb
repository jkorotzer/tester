class Employer < ActiveRecord::Base
  has_secure_password
  has_many :employees
  has_many :addresses
  has_many :timesheets
end