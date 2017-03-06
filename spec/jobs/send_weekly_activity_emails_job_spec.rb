require 'rails_helper'

RSpec.describe SendWeeklyActivityEmailsJob, type: :job do
  let(:user) { create(:user) }
  subject(:job) { described_class.perform_later }

  it 'queues the job' do
    expect { job }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'is in default queue' do
    expect(SendWeeklyActivityEmailsJob.new.queue_name).to eq 'default'
  end

  it 'calls the user mailer' do
    users_list = [ { "recipient_id" => user.id }, { "recipient_id" => 2 } ]

    allow(NotifiableUsersQuery)
      .to receive_message_chain(:new, :find_notifiable_users)
      .and_return(users_list)

    allow(UserMailer)
      .to receive_message_chain(:weekly_activity_summary, :deliver_later)

    described_class.new.perform

    expect(UserMailer).to have_received(:weekly_activity_summary)
      .with(user.id)
  end
end
