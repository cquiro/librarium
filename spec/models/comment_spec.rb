require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:book) { create(:book, title: 'Title') }
  let(:comment) { build(:comment, book_id: book.id) }

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

  it "is invalid without a user_id" do
    no_user_id_comment = build(:comment, user_id: nil)
    no_user_id_comment.valid?
    expect(no_user_id_comment.errors[:user_id]).to include("can't be blank") 
  end

  it "is invalid without a book_id" do
    no_book_id_comment = build(:comment, book_id: nil)
    no_book_id_comment.valid?
    expect(no_book_id_comment.errors[:book_id]).to include("can't be blank") 
  end
end
