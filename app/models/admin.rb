class Admin < ActiveRecord::Base
  validates :username, presence: true, length: { maximum: 50 }
  validates :password, presence: true, length: { maximum: 50 }

  
end
