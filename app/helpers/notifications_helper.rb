module NotificationsHelper
  def read_link(notification)
      link_to 'x', notification_read_path(id: notification.id), class: 'close', :data => {:confirm => 'Please help your friends!'}, :method => :read
  end
end
