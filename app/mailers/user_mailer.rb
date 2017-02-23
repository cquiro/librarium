# mailer to handle user comms.
class UserMailer < ApplicationMailer
  default from: 'librarium.mailer@gmail.com'

  def new_follower_notification(follower, user)
    @user = user
    @follower = follower
    mail(to: "#{user.name} <#{user.email}>",
         subject: 'You have a new follower on Librarium')
  end
end
