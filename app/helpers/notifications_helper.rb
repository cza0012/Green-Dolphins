module NotificationsHelper
  def read_link(notification)
      link_to 'x', read_notification_path(id: notification.id), class: 'close', :data => {:confirm => 'Delete notification!'}, :method => :put, remote: true
  end
end
