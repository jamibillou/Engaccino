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
    init_page :title => 'menu_messages', :javascripts => 'messages'
    @contacts = current_user.messaged_contacts
    @messages = current_user.messages
    @message  = Message.new
  end
  
  def show
    init_page :javascripts => 'messages'
    @messages = current_user.messages
    @message  = Message.new
    render :partial => 'messages/conversation', :locals => { :contact => User.find(params[:contact_id]) }
  end
end
