#app/models/message.rb

class Message < Application Record 
    belongs_to :chatroom
    belongs_to :user
end