require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  # before { @user = FactoryGirl.build(:user) }

  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authentication_token) }

  it "is valid with name, email, password and password_digest" do
    expect(user).to be_valid
  end
  
  it "is invalid without a name" do
    no_name_user = build(:user, name: nil)
    no_name_user.valid?
    expect(no_name_user.errors[:name]).to include("can't be blank") 
  end

  it "is invalid without an email" do
    no_email_user = FactoryGirl.build(:user, email: nil)
    no_email_user.valid?
    expect(no_email_user.errors[:email]).to include("can't be blank") 
  end
end
