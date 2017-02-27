ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Newest Users' do
          table_for User.order('id desc').limit(10).each do
            column(:name) { |user| link_to(user.name, admin_user_path(user)) }
            column :email
          end
        end
      end

      column do
        panel 'Highest Rated Books' do
          table_for Book.order('avg_score desc').limit(10).each do
            column(:title) { |book| link_to(book.title, admin_book_path(book)) }
            column :genre
            column 'Score', :avg_score
          end
        end
      end
    end

    columns do
      column do
        panel 'Latest Comments' do
          table_for Comment.order('id desc').limit(10).each do
            column(:book) do |comm|
              link_to(comm.book.title, admin_book_path(comm.book))
            end

            column(:comment) do |comm|
              link_to(comm.body, admin_comment_path(comm))
            end

            column(:by_user) do |comm|
              link_to(comm.user.name, admin_user_path(comm.user))
            end
          end
        end
      end
    end
  end # content
end
