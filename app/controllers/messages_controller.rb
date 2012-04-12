class MessagesController < ApplicationController
  
  before_filter :authenticate
  after_filter  :read_messages!, :only => [:show,:create]
  
  def create
    @message = Message.new params[:message]
    unless @message.save
      respond_to { |format| format.html { render :json => @message.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => @message.recipient_id.to_s if request.xhr? } }
    end 
  end
  
  def new
    @message = Message.new
    render :partial => 'messages/new_conversation'
  end
  
  def index
    init_page :title => 'menu_messages', :javascripts => 'messages'
    @contacts = current_user.messaged_contacts
    @messages = current_user.messages
    @message  = Message.new
    read_messages! @contacts.first
  end
  
  def show
    init_page :javascripts => 'messages'
    @messages = current_user.messages
    @message  = Message.new
    render :partial => 'messages/conversation', :locals => { :contact => User.find(params[:contact_id]) }
  end
  
  def refresh_menu
    render :partial => 'messages/refresh_menu'
  end
  
  private
    def read_messages!(contact_id = params[:contact_id])
      Message.where(:author_id => contact_id, :recipient_id => current_user, :read => false).each { |message| message.update_attribute :read, true }
    end
end
