# Each book insatance will have many comments.
# A Book instance will have many users through favorites and also
# it will have many users through wishlists.
class Book < ActiveRecord::Base
  has_many :comments
  has_many :favorites
  has_many :wishlists
  has_many :ratings
  validates :title, :author, :genre, :pub_date, presence: true

  scope :filter_by_title, lambda { |title|
    where('lower(title) LIKE ?', "%#{title.downcase}%")
  }

  scope :filter_by_author, lambda { |author|
    where('lower(author) LIKE ?', "%#{author.downcase}%")
  }

  scope :filter_by_genre, lambda { |genre|
    where('lower(genre) LIKE ?', "%#{genre.downcase}%")
  }

  scope :filter_by_year, lambda { |year|
    where('extract(year from pub_date) = ?', year.to_s)
  }

  scope :below_eq_score, lambda { |avg_score|
    where('avg_score <= ?', avg_score)
  }

  scope :above_eq_score, lambda { |avg_score|
    where('avg_score >= ?', avg_score)
  }

  def calculate_avg_score
    sum = ratings.inject(0.0) { |accum, rating| accum + rating.score }
    sum / ratings.size
  end

  def self.search(params = {})
    books = Book.all
    books = words_filter(books, params)
    books = books.filter_by_year(params[:year]) if params[:year]
    books = score_filter(books, params)
    books
  end

  def self.words_filter(books, params = {})
    books = books.filter_by_title(params[:title]) if params[:title]
    books = books.filter_by_author(params[:author]) if params[:author]
    books = books.filter_by_genre(params[:genre]) if params[:genre]
    books
  end

  def self.score_filter(books, params = {})
    books = books.below_eq_score(params[:max_score].to_f) if params[:max_score]
    books = books.above_eq_score(params[:min_score].to_f) if params[:min_score]
    books
  end
end
