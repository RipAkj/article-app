require 'readingtime'
class DraftsController < ApplicationController
  before_action :require_authentication

  def show
    @draft=Article.find(params[:id])
    render json:@draft
  end

  def index
    drafts=@current_user.articles
    drafts=drafts.select{|draft|
      draft.has_published==false
    }
    render json:drafts
  end

  def create
    #render plain: params[:article]
    @draft = Article.new(params.require(:draft).permit(:title, :description, :like, :comment))
    @draft.user = @current_user
    @draft.readingtime=@draft.description.reading_time
    @draft.has_published=false
    if @draft.save
      render json:@draft, status: :created
    else
      render json: { errors:@current_user }, status: :unprocessable_entity
    end
  end

  def update
    @draft = Article.find(params[:id])
    if @draft.user != @current_user
      return render json: {msg: "you are not author of this draft"}
    end
    if @draft.update(params.require(:draft).permit(:title, :description, :like, :comment))
      @draft.readingtime=@draft.description.reading_time
      render json: @draft, status: :ok
      return
    else
      render json:{errors: @draft.errors.full_messages}
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if @article.user != @current_user
      return render json: {msg: "you are not author of article"}
    end
    if @article.destroy
      render json: {msg: "given article deleted succesfully"}, status: :ok
    else
      render json: {errors: @article.errors.full_messages}, status: :no_content
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
