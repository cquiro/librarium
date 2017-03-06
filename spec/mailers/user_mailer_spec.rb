require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:follower) { create(:user) }

  describe "new_follower_notification email" do
    let(:email) {
      described_class.new_follower_notification(follower, user).deliver_now
    }

    it 'renders the subject' do
      expect(email.subject).to eq 'You have a new follower on Librarium'
    end

    it 'renders the receiver email' do
      expect(email.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(email.from).to eq(['librarium.mailer@gmail.com'])
    end

    it 'includes user name in the body of the email' do
      expect(email.body.encoded).to include user.name
    end

    it 'includes follower name in the body of the email' do
      expect(email.body.encoded).to include follower.name
    end

    it 'sends an email' do
      expect { email }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe "weekly_activity_summary email" do
    let(:followed) { create(:user) }

    let(:activity) { [ { "notifier_id" => followed.id, "fav_count" => 8,
                         "comm_count" => 10, "wish_count" => 5 } ] }

    let(:email) {
      described_class.weekly_activity_summary(user.id)
    }

    it 'renders the subject' do
      expect(email.subject).to eq 'Weekly Librarium Activity Summary'
    end

    it 'renders the receiver email' do
      expect(email.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(email.from).to eq(['librarium.mailer@gmail.com'])
    end

    it 'includes user name in the body of the email' do
      expect(email.body.encoded).to include user.name
    end

    it 'includes the name of the followed user in the body of the email' do
      allow(NotifiableUsersQuery)
        .to receive_message_chain(:new, :activity_report).with(user.id)
        .and_return(activity)

      expect(email.body.encoded).to include followed.name 
    end

    it "includes 'favorited 8 books' in the body of the email" do
      allow(NotifiableUsersQuery)
        .to receive_message_chain(:new, :activity_report).with(user.id)
        .and_return(activity)

      expect(email.body.encoded).to include 'favorited 8 books' 
    end

    it 'adds email to mailers queue when asked to deliver_later' do
      expect { email.deliver_later }.to have_enqueued_job.on_queue('mailers')
    end
  end
end
