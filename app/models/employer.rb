class Employer < ActiveRecord::Base
  has_secure_password
  has_many :employees
  has_many :addresses
  has_many :timesheets
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }

end