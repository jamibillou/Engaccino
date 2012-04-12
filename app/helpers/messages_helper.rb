module MessagesHelper
  
  def unread_messages?
    Message.where(:recipient_id => current_user, :read => false).count > 0
  end
  
  def unread_messages_from?(author)
    Message.where(:author_id => author, :recipient_id => current_user, :read => false).count > 0
  end
end
