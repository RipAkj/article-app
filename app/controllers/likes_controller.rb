class LikesController < ApplicationController
  before_action :require_authentication
  protect_from_forgery with: :null_session

  def create
    @existing_like = Like.find_by(user_id: @current_user.id, article_id: params[:id])
    if @existing_like
      @article=Article.find(@existing_like.article_id)
      @article.like=@article.like-1
      @article.save
      @existing_like.destroy
      return  render json: {msg: @article}, status: :ok
    end
    @like = Like.new(article_id:params[:id])
    @like.user_id = @current_user.id
    if @like.save
      @article=Article.find(@like.article_id)
      @article.like=@article.like+1
      @article.save
      render json: {msg: @article}, status: :ok
    else
      render json: {errors: @like.errors.full_messages}, status: :no_content
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
