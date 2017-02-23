require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:rating) { Rating.new(user_id: 1, book_id: 1, score: 10) }

  subject { rating }

  it { should respond_to(:score) }
  it { should respond_to(:user_id) }
  it { should respond_to(:book_id) }

  it "is valid" do
    expect(rating).to be_valid
  end
  
  it "is invalid without a score" do
    no_score_rating = Rating.new(user_id: 1, book_id: 1, score: '')
    no_score_rating.valid?
    expect(no_score_rating.errors[:score]).to include("can't be blank") 
  end

  it "is invalid without a user_id" do
    no_user_id_rating = Rating.new(user_id: '', book_id: 1, score: 10)
    no_user_id_rating.valid?
    expect(no_user_id_rating.errors[:user_id]).to include("can't be blank") 
  end

  it "is invalid without a book_id" do
    no_book_id_rating = Rating.new(user_id: 1, book_id: '', score: 10)
    no_book_id_rating.valid?
    expect(no_book_id_rating.errors[:book_id]).to include("can't be blank") 
  end
end
