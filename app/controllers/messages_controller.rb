class MessagesController < ApplicationController
  
  before_filter :authenticate
  
  def create
    @message = Message.new params[:message]
    unless @message.save
      respond_to { |format| format.html { render :json => @message.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => 'create!' if request.xhr? } }
    end 
  end
  
  def index
    @title    = I18n.t 'menu_messages'
    @contacts = current_user.contacts_id.map { |contact_id| User.find contact_id }
    @messages = current_user.messages
  end
end
