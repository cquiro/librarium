# mailer to handle user comms.
class UserMailer < ApplicationMailer
  default from: 'librarium.mailer@gmail.com'

  def new_follower_notification(follower, user)
    @user = user
    @follower = follower
    mail(to: "#{user.name} <#{user.email}>",
         subject: 'You have a new follower on Librarium')
  end

  def weekly_activity_summary(recipient_id)
    @recipient = User.find(recipient_id)
    @activity_array = NotifiableUsersQuery.new.activity_report(recipient_id)
    mail(to: "#{@recipient.name} <#{@recipient.email}>",
         subject: 'Weekly Librarium Activity Summary')
  end
end
