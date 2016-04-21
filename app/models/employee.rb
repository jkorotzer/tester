class Employee < ActiveRecord::Base
  has_secure_password
  belongs_to :employer
  has_many :timesheets
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }

end