ActiveAdmin.register Book do
  permit_params :title, :author, :pub_date, :genre, :cover, :synopsis,
                :language, :edition, :publisher, :avg_score

  filter :title
  filter :author
  filter :genre
  filter :pub_date
  filter :avg_score
  filter :synopsis
  filter :language
  filter :edition
  filter :publisher
  filter :created_at
  filter :updated_at

  index as: :grid do |book|
    div do
      a href: admin_book_path(book) do
        image_tag(book.cover)
      end
    end
    a truncate(book.title), href: admin_book_path(book)

    # selectable_column
    # column :id
    # column :title
    # column :author
    # column :genre
    # column :language
    # column :avg_score
    # actions
  end
end
