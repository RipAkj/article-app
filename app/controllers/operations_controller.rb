require 'readingtime'
class OperationsController < ApplicationController
  before_action :require_authentication

  def sortByLike
    @articles = Article.all.sort_by { |article| -article.like }
    render json:@articles, status: :ok
  end

  def sortByComment
    @articles = Article.all.sort_by { |article| -article.comment }
    render json:@articles, status: :ok
  end

  def articleSearch
    @articles=Article.where("title LIKE ?", "%#{params[:s]}%")
    render json:@articles, status: :ok
  end

  def searchTopic
    @articles=Article.where("topic LIKE ?", "%#{params[:s]}%")
    render json:@articles, status: :ok
  end
  def userSearch
    @users=User.where("username LIKE ?", "%#{params[:s]}%")
    render json:@users, status: :ok
  end

  def topArticles
    @articles=Article.all.sort_by { |article| -(article.comment+article.like) }.first(5)
    render json:@articles, status: :ok
  end

  def similarArticles
    @thisArticle=Article.find(params[:id])
    @c=[]
    @a=@thisArticle.topic.split(/\W+/)
    @a.each do |a1|
      @articles=Article.where("topic LIKE ?", "%#{a1}%")
      @articles.each do |article|
        if not @c.include?article
          @c.push(article)
        end
      end
    end
    render json:@c, status: :ok
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
    render json:@a, status: :ok
  end


  def recommendedArticles
    @user=User.find(params[:id])
    @following=Friendship.where(follower_id:@user)
    @articlesOfFollowing=[]
    @following.each do |user|
      @a=Article.where(user_id:user)
      @a.each do |a1|
        @articlesOfFollowing.push(a1)
      end
    end
    render json:@articlesOfFollowing
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
