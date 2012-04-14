class MessagesController < ApplicationController
  
  before_filter :authenticate
  after_filter  :read_messages!, :only => [:show,:create]
  
  def new
    @message = Message.new
    render :partial => 'messages/new_conversation'
  end
  
  def create
    @message = Message.new params[:message]
    unless @message.save
      respond_to { |format| format.html { render :json => @message.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => @message.recipient_id.to_s if request.xhr? } }
    end 
  end
  
  def index
    init_page :title => 'menu_messages', :javascripts => 'messages'
    @contacts = current_user.messaged_contacts
    @contact_id = @contacts.empty? ? 0 : @contacts.first.id
    @messages = current_user.messages
    @message  = Message.new
    read_messages! @contacts.first
  end
  
  def show
    init_page :javascripts => 'messages'
    @messages = current_user.messages
    @message  = Message.new
    contact_id = params[:contact_id].nil? ? current_user.messaged_contacts.first.id : params[:contact_id].to_i
    render :partial => 'messages/conversation', :locals => { :contact => User.find(contact_id) }
  end
  
  def menu_top
    render :partial => 'messages/menu_top'
  end
  
  def menu_left
    @contacts = current_user.messaged_contacts
    @messages = current_user.messages
    @contact_id = params[:contact_id].nil? ? @contacts.first.id : params[:contact_id].to_i
    destroy_archives
    render :partial => 'messages/menu_left', :locals => { :contacts => @contacts, :messages => @messages, :contact_id => @contact_id }
  end
  
  def archive
    contact_id = params[:contact_id]
    Message.where(:author_id => current_user, :recipient_id => contact_id).each { |message| message.update_attribute :archived_author, true }
    Message.where(:author_id => contact_id, :recipient_id => current_user).each { |message| message.update_attribute :archived_recipient, true }
    respond_to { |format| format.html { render :json => 'archive!' if request.xhr? } }
  end
  
  private
    def read_messages!(contact_id = params[:contact_id])
      Message.where(:author_id => contact_id, :recipient_id => current_user, :read => false).each { |message| message.update_attribute :read, true }
    end
    
    def destroy_archives
      Message.where(:archived_author => true, :archived_recipient => true).each { |message| message.destroy }
    end
end
