# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def weekly_activity_summary
    UserMailer.weekly_activity_summary(1)
  end
end
