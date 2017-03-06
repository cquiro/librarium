# Query class to get a list of users to notifiy
class NotifiableUsersQuery
  def find_notifiable_users
    query = "SELECT distinct users.id as recipient_id
             FROM users
             INNER JOIN connections
               ON users.id = connections.user_id
             LEFT JOIN notifications
               ON connections.followee_id = notifications.notifier_id
             WHERE notifications.created_at > current_date - interval '7' day
             ORDER BY users.id ASC;"

    ActiveRecord::Base.connection.execute(query)
  end

  def activity_report(notified_user_id)
    query = "SELECT a.notifier_id, SUM(CASE WHEN a.notifiable_type = 'Favorite'
      THEN 1 ELSE 0 END) AS fav_count, SUM(CASE WHEN
      a.notifiable_type = 'Comment' THEN 1 ELSE 0 END) AS comm_count, SUM(CASE
      WHEN a.notifiable_type = 'Wishlist' THEN 1 ELSE 0 END) AS wish_count FROM
      (SELECT notifications.notifier_id, notifications.notifiable_type FROM
      users INNER JOIN connections ON users.id = connections.user_id INNER JOIN
      notifications ON connections.followee_id = notifications.notifier_id WHERE
      notifications.created_at > current_date - interval '7' day AND
      users.id = #{notified_user_id}) a GROUP BY a.notifier_id;"

    ActiveRecord::Base.connection.execute(query)
  end
end
