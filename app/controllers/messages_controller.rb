class MessagesController < ApplicationController
  
  before_filter :authenticate
  before_filter :ajax_only,         :only => [:new, :show, :menu_top, :menu_left]
  before_filter :destroy_archives!, :only => [:menu_left]
  before_filter :signed_up,         :only => [:index]
  after_filter  :read_messages!,    :only => [:show,:create]
  
  def index
    init_page :title => 'messages.title', :javascripts => 'messages'
    @contacts = current_user.messaged_contacts
    @current_contact = @contacts.empty? ? 0 : @contacts.first.id
    @messages = current_user.messages
    @message  = Message.new
    read_messages! @contacts.first
  end
  
  def show
    init_page :javascripts => 'messages'
    @messages = current_user.messages
    @message  = Message.new
    current_contact = params[:current_contact].nil? ? current_user.messaged_contacts.first.id : params[:current_contact].to_i
    render :partial => 'messages/conversation', :locals => { :contact => User.find(current_contact) }
  end
  
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
  
  def menu_top
    render :partial => 'messages/menu_top'
  end
  
  def menu_left
    @contacts = current_user.messaged_contacts
    @messages = current_user.messages
    @current_contact = params[:current_contact].nil? ? @contacts.first.id : params[:current_contact].to_i
    render :partial => 'messages/menu_left', :locals => { :contacts => @contacts, :messages => @messages, :current_contact => @current_contact }
  end
  
  def archive
    current_contact = params[:current_contact]
    Message.where(:author_id => current_user,    :recipient_id => current_contact).each { |message| message.update_attribute :archived_author,    true }
    Message.where(:author_id => current_contact, :recipient_id => current_user).each    { |message| message.update_attribute :archived_recipient, true }
    respond_to { |format| format.html { render :json => 'archive!' if request.xhr? } }
  end
  
  private
    def read_messages!(current_contact = params[:current_contact])
      Message.where(:author_id => current_contact, :recipient_id => current_user, :read => false).each { |message| message.update_attribute :read, true }
    end
    
    def destroy_archives!
      Message.where(:archived_author => true, :archived_recipient => true).each { |message| message.destroy }
    end
end
