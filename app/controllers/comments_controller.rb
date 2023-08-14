class CommentsController < ApplicationController
  before_action :require_authentication
  protect_from_forgery with: :null_session

  def show
    @article=Article.find(params[:id])
    @comments=@article.comments
    render json: @comments, status: :ok
  end

  def create
    @comment = Comment.new(params.require(:comment).permit(:text, :article_id))
    @comment.user_id = @current_user.id
    if @comment.save
      @article=Article.find(@comment.article_id)
      @article.comment=@article.comment+1
      @article.save
      @revision=Revision.new(user_id:@current_user.id)
      @revision.action=@current_user.username.to_s + ' commented on ' + @article.id.to_s
      @revision.save
      render json: @comment, status: :created
    else
      render json: { error:@comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.user_id != @current_user.id
      return render json: {msg: "you are not the author"}, status: :unauthorized
    end
    if @comment.update(params.require(:comment).permit(:text, :article_id))
      @revision=Revision.new(user_id:@current_user.id)
      @revision.action=@current_user.username.to_s + ' updated commented on Article ' + @comment.article_id.to_s
      @revision.save
      render json: @comment, status: :ok
    else
      render json: { error:@comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user_id != @current_user.id
      return render json: {msg: "you are not the author"}, status: :unauthorized
    end
    if @comment.destroy
      @article=Article.find(@comment.article_id)
      @article.comment=@article.comment-1
      @article.save
      @revision=Revision.new(user_id:@current_user.id)
      @revision.action=@current_user.username.to_s + ' deleted commented on ' + @article.id.to_s
      @revision.save
      render json: {msg: "this comment has been deleted"}, status: :ok
    else
      render json: {errors: @comment.errors.full_messages}, status: :no_content
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
