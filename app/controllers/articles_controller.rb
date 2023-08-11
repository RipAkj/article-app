
class ArticlesController < ApplicationController
  before_action :require_authentication
  def show
    render json:@article=Article.find(params[:id])
  end
  def index
    render json:@articles = Article.all
    if params[:date]
      @articles = @articles.where(created_at: params[:date].to_date.beginning_of_day..params[:date].to_date.end_of_day)
      render json:@articles
    end
  end

  def create
    #render plain: params[:article]
    @article = Article.new(params.require(:article).permit(:title, :description, :like,:comment))
    @article.user = @current_user
    if @article.save
      render json:@article, status: :created
    else
      render json: { errors:@current_user }, status: :unprocessable_entity
    end
  end
  def update
    @article = Article.find(params[:id])
    if @article.user != @current_user
      return render json: {msg: "you are not author of this article"}
    end
    if @article.update(params.require(:article).permit(:title, :description, :like, :comment))
      render json: @article, status: :ok
      return
    else
      render json:{errors: @article.errors.full_messages}
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
  #/sortByLike
  def sortByLike
    @articles = Article.all.sort_by { |article| -article.like }
    render json:@articles
  end
  # /sortByComment
  def sortByComment
    @articles = Article.all.sort_by { |article| -article.comment }
    render json:@articles
  end
  # articleSearch s = ""
  def search
    @articles=Article.where("title LIKE ?", "%#{params[:s]}%")
    render json:@articles
  end
  #find articles in id range
  #Article.where(:id=>1..10)
  # topicSearch s = ""
  def searchTopic
    @articles=Article.where("topic LIKE ?", "%#{params[:s]}%")
    render json:@articles
  end
  def topArticles
    @articles=Article.all.sort_by { |article| -(article.comment+article.like) }.first(5)
    render json:@articles
  end
  def similarArticles
    @thisArticle=Article.find(params[:id])
    @articles=Article.where("topic LIKE ?", "%#{@thisArticle.topic}%")
    render json:@articles
  end
  def listTopic
    @topics=Article.distinct.pluck(:topic)
    @a=[]
    @topics.each do |topic|
      @b= ( topic.split(/\W+/))
      @b.each do |b1|
        if not @a.include?b1
          @a.push(b1)
        end
      end
    end
    render json:@a
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
