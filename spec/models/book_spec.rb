require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { build(:book) }

  subject { book }

  it { should respond_to(:title) }
  it { should respond_to(:author) }
  it { should respond_to(:pub_date) }
  it { should respond_to(:genre) }
  it { should respond_to(:cover) }
  it { should respond_to(:synopsis) }
  it { should respond_to(:language) }
  it { should respond_to(:edition) }
  it { should respond_to(:publisher) }
  it { should respond_to(:avg_score) }

  it "is valid with all attributes" do
    expect(book).to be_valid
  end
  
  it "is invalid without a title" do
    no_title_book = build(:book, title: nil)
    no_title_book.valid?
    expect(no_title_book.errors[:title]).to include("can't be blank") 
  end

  it "is invalid without an author" do
    no_author_book = build(:book, author: nil)
    no_author_book.valid?
    expect(no_author_book.errors[:author]).to include("can't be blank") 
  end
  
  it "is invalid without a genre" do
    no_genre_book = build(:book, genre: nil)
    no_genre_book.valid?
    expect(no_genre_book.errors[:genre]).to include("can't be blank") 
  end

  it "is invalid without a pub_date" do
    no_puub_date_book = build(:book, pub_date: nil)
    no_puub_date_book.valid?
    expect(no_puub_date_book.errors[:pub_date]).to include("can't be blank") 
  end

  describe "search engine" do
    before :each do
      @book1 = create(:book, 
                      title: 'Sapiens: A brief History of Humankind', 
                      author: 'Yuval Noah Harari',
                      genre: 'Anthropology',
                      pub_date: Date.new(2014),
                      avg_score: 10)
      @book2 = create(:book, 
                      title: 'The Quest',
                      author: 'Daniel Yergin',
                      genre: 'Non-fiction',
                      pub_date: Date.new(2011),
                      avg_score: 9.5)
      @book3 = create(:book, 
                      title: 'The Prize',
                      author: 'Daniel Yergin',
                      genre: 'Non-fiction',
                      pub_date: Date.new(1990),
                      avg_score: 10)
      @book4 = create(:book, 
                      title: 'New York',
                      author: 'Edward Rutherford',
                      genre: 'Historical Drama',
                      pub_date: Date.new(2009),
                      avg_score: 8.5)
    end

    describe "scopes for title, author, genre, pub_date and avg_score" do
      context "when a 'The' title pattern is sent" do
        it "returns the 2 books matching" do
          expect(Book.filter_by_title('The').count).to eq 2
        end

        it "returns the books matching" do
          expect(
            Book.filter_by_title('The').sort
          ).to match_array([@book2, @book3])
        end
      end

      context "when a 'Yergin' author pattern in sent" do
        it "returns the 2 books matching" do
          expect(Book.filter_by_author('Yergin').count).to eq 2
        end

        it "returns the books matching" do
          expect(
            Book.filter_by_author('Yergin').sort
          ).to match_array([@book3, @book2])
        end
      end

      context "when 'Anthropology' genre pattern is sent" do
        it "returns 1 book matching" do
          expect(Book.filter_by_genre('Anthropology').count).to eq 1
        end

        it "returns the book matching" do
          expect(
            Book.filter_by_genre('Anthropology').sort
          ).to match_array([@book1])
        end
      end

      context "when '2009' genre pattern is sent" do
        it "returns 1 book matching" do
          expect(Book.filter_by_year(2009).count).to eq 1
        end

        it "returns the book matching" do
          expect(
            Book.filter_by_year('2009').sort
          ).to match_array([@book4])
        end
      end

      context "filtering by total book score" do
        it "returns the books with an average score >= than specified" do
          expect(
            Book.above_eq_score(9.5).sort
          ).to match_array([@book1, @book3, @book2])
        end

        it "returns the books with an average score <= than specified" do
          expect(
            Book.below_eq_score(9.5).sort
          ).to match_array([@book2, @book4])
        end

        it "returns an empty array if conditions are not met" do
          expect(
            Book.below_eq_score(0).sort
          ).to match_array([])
        end
      end
    end

    describe ".search" do
      context "when title 'brief'" do
        it "returns @book1" do
          search_hash = { title: 'brief' }
          expect(Book.search(search_hash)).to match_array([@book1]) 
        end
      end

      context "when author 'edward'" do
        it "returns @book4" do
          search_hash = { author: 'edward' }
          expect(Book.search(search_hash)).to match_array([@book4]) 
        end
      end
        
      context "when genre 'pology'" do
        it "returns @book1" do
          search_hash = { genre: 'pology' }
          expect(Book.search(search_hash)).to match_array([@book1]) 
        end
      end

      context "when year '1990'" do
        it "returns @book3" do
          search_hash = { year: '1990' }
          expect(Book.search(search_hash)).to match_array([@book3]) 
        end
      end

      context "when avg_score less or equal to 9.5" do
        it "returns @book2 and @book4" do
          search_hash = { max_score: '9.5' }
          expect(Book.search(search_hash)).to match_array([@book2, @book4]) 
        end
      end

      context "when avg_score higher or equal to 9.5" do
        it "returns @book1, @book2 and @book3" do
          search_hash = { min_score: '9.5' }
          expect(
            Book.search(search_hash)
          ).to match_array([@book1, @book2, @book3]) 
        end
      end

      context "when title 'new' and avg_score higher than 9" do
        it "returns an empty array" do
          search_hash = { title: "new", min_score: '9' }
          expect(Book.search(search_hash)).to be_empty
        end
      end

      context "when title 'the', avg_score higher than 9.8" do
        it "returns @book3" do
          search_hash = { title: "the", min_score: '9.8' }
          expect(Book.search(search_hash)).to match_array([@book3])
        end
      end

      context "when avg_score between 9 and 9.8" do
        it "returns @book2" do
          search_hash = { max_score: 9.8, min_score: 9 }
          expect(Book.search(search_hash)).to match_array([@book2]) 
        end
      end

      context "when genre 'non-fiction' and title 'prize'" do
        it "returns @book3" do
          search_hash = { genre: 'non-fiction', title: 'prize' }
          expect(Book.search(search_hash)).to match_array([@book3])
        end
      end

      context "when empty hash" do
        it "returns all books" do
          search_hash = {}
          expect(
            Book.search(search_hash)
          ).to match_array([@book4, @book3, @book2, @book1])
        end
      end
    end
  end
end
