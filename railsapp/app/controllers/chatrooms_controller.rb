# app/controllers/chatrooms_controller.rb

class ChatroomsController < ApplicationController 

    def show
        @chatroom = Chatroom.find_by(slug: param[:slug])
        @message = Message.new 
    end
end