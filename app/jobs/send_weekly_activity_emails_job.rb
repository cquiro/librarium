# Background job to send weekly activity emails.
class SendWeeklyActivityEmailsJob < ApplicationJob
  queue_as :default

  def perform
    mail_recipients = NotifiableUsersQuery.new.find_notifiable_users

    mail_recipients.each do |recipient|
      UserMailer.weekly_activity_summary(
        recipient['recipient_id']
      ).deliver_later
    end
  end
end
