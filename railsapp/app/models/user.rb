#app/models/user.rb

class User < ApplicationRecord
    has_many :messages
    has_many :chatrooms, through :messages
    validate :username, presence: true, uniqueness: true
end 