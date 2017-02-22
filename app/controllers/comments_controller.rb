# Comments model belongs to book and to user.
class CommentsController < ApplicationController
  def show
    comment = Comment.find(params[:id])
    render json: comment, status: :ok
  end

  def index
    comments = Comment.where(book_id: params[:book_id])
    render json: comments, status: :ok
  end

  def create
    authorize :comment
    comment = book.comments.build(comments_params)
    comment.user_id = current_user.id
    if comment.save
      render json: comment, status: :ok
    else
      render json: { errors: comment.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize comment
    if comment.update(comments_params)
      render json: comment, status: :ok
    else
      render json: { errors: comment.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize comment
    comment.destroy
    head :no_content
  end

  private

  def comment
    @comment ||= book.comments.find(params[:id])
  end

  def book
    @book ||= Book.find(params[:book_id])
  end

  def comments_params
    params.require(:comment).permit(:body)
  end
end
