require 'readingtime'
class ArticlesController < ApplicationController
  before_action :require_authentication

  def show
    @article=Article.find(params[:id])
    render json: @article, status: :ok
  end

  def index
    @articles = Article.all.select{ |article|
      article.has_published==true
    }
    render json: @articles,status: :ok
  end

  def create
    @article = Article.new(params.require(:article).permit(:title, :description, :like, :comment, :topic))
    @article.user = @current_user
    @article.readingtime=@article.description.reading_time
    @article.has_published=true
    if @article.save
      @revision=Revision.new(title:@article.title,description:@article.description,topic:@article.topic)
      @revision.user=@current_user
      @revision.action="created"
      @revision.save
      render json: @article, status: :created
    else
      render json: { error:@article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.user != @current_user
      return render json: {msg: "you are not author of this article"}, status: :unauthorized
    end
    if @article.update(params.require(:article).permit(:title, :description, :like, :comment, :topic))
      @article.readingtime=@article.description.reading_time
      @revision=Revision.new(title:@article.title,description:@article.description,topic:@article.topic)
      @revision.user=@current_user
      @revision.action="updated"
      @revision.save
      render json: @article, status: :ok
      return
    else
      render json: {error: @article.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    id=@article.id
    if @article.user != @current_user
      return render json: {msg: "you are not author of article"}, status: :unauthorized
    end
    @temp=@article
    if @article.destroy
      @revision=Revision.new(title:@article.title,description:@article.description,topic:@article.topic)
      @revision.user=@current_user
      @revision.action="deleted"
      @revision.save
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
