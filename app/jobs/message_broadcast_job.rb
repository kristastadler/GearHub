class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    mine = ApplicationController.render(
      partial: 'messages/mine', 
      locals: { message: message }
    )
    theirs = ApplicationController.render(
      partial: 'messages/theirs', 
      locals: { message: message }
    )

    ActionCable.server.broadcast "room_channel_#{message.room_id}", mine: mine, theirs: theirs, message: message
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end