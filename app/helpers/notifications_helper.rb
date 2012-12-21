module NotificationsHelper
  def read_link(notification)
      link_to '<i class="icon-remove"></i> Delete'.html_safe, notification_read_path(id: notification.id), method: :read, class: 'btn btn-small'
  end
end
