class CommentsController < ApplicationController
  before_action :require_authentication
  protect_from_forgery with: :null_session
  def create
    @comment = Comment.new(params.require(:comment).permit(:text, :article_id))
    @comment.user_id = @current_user.id

    if @comment.save
      @article=Article.find(@comment.article_id)
      @article.comment=@article.comment+1
      @article.save
      render json: @article
    else
      render json: @comment.errors.full_messages
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.user_id != @current_user.id
      return render json: {msg: "you are not the author"}
    end
    if @comment.update(params.require(:comment).permit(:text, :article_id))
      render json: @comment
    else
      render json: @comment.errors.full_messages
    end

  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user_id != @current_user.id
      return render json: {msg: "you are not the author"}
    end
    if @comment.destroy
      @article=Article.find(@comment.article_id)
      @article.comment=@article.comment-1
      @article.save
      render json: {msg: "this comment has been deleted"}
    else
      render json: @comment.errors.full_messages
    end
  end

  private

  def require_authentication
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    begin
      decoded_token = JWT.decode(token, 'your_secret_key', true, algorithm: 'HS256')
      render json: {error: "invalid token"} if !decoded_token[0]['user_id']
      @current_user = User.find(decoded_token[0]['user_id'])
    rescue JWT::DecodeError
      render json: { error: header }, status: :unauthorized
    end
  end
end
