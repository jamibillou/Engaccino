module MessagesHelper
  
  def get_unread_messages
    nb = Message.where(:recipient_id => current_user, :read => false).count
    nb > 0 ? " (#{nb})" : ""
  end
  
  def unread_messages?(author)
    Message.where(:author_id => author, :recipient_id => current_user, :read => false).count > 0
  end
end
