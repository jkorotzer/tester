class Address < ActiveRecord::Base
  belongs_to :employer
  validates :address, presence: true, length: { minimum: 3, maximum: 50 }

end