require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:follower) { create(:user) }
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
