
class ArticlesController < ApplicationController
  protect_from_forgery with: :null_session
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
  def new
    render json:@article = Article.new
  end
  def edit
    render json:@article = Article.find(params[:id])
  end
  def create
    #render plain: params[:article]
    @article = Article.new(params.require(:article).permit(:title, :description,:user_id, :like,:comment))
    @article.user_id=params[:id]

    if @article.save
      render json:@article
    else
      render json: @article.errors.full_messages
    end
  end
  def update
    @article = Article.find(params[:id])
    if @article.update(params.require(:article).permit(:title, :description, :like, :comment))
      render json:"Article was updated successfully"
      return
    else
      render json: @article.errors.full_messages
    end
  end
  def destroy
    @article = Article.find(params[:id]).destroy
    render json:"Article was deleted successfully"
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
end
