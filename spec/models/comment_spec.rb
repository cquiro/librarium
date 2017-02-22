require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { build(:comment) }

  subject { comment }

  it { should respond_to(:body) }
  it { should respond_to(:user_id) }
  it { should respond_to(:book_id) }

  it "is valid with a body" do
    expect(comment).to be_valid
  end
  
  it "is invalid without a body" do
    no_body_comment = build(:comment, body: nil)
    no_body_comment.valid?
    expect(no_body_comment.errors[:body]).to include("can't be blank") 
  end
end
