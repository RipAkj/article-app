class ViewedarticlesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :require_authentication

  def create
    viewed_articles = (@current_user.viewed_articles)
    viewed_articles_today = viewed_articles.select{|obj|
     Date.parse(obj.created_at.to_s) == Date.today
  }.length
    membership = 0
    if @current_user.subscriptions
      membership = @current_user.subscriptions.last[:membership]
    end
    if membership == 1 && viewed_articles_today == 3
      return render json: {msg: "Subscription limit reached.Upgrade membership to view more post"}, status: :unauthorized
    elsif membership == 2 && viewed_articles_today == 5
      return render json: {msg: "Subscription limit reached.Upgrade membership to view more post"}, status: :unauthorized
    elsif membership == 3 && viewed_articles_today == 10
      return render json: {msg: "Subscription limit reached.Upgrade membership to view more post"}, status: :unauthorized
    elsif membership == 0 && viewed_articles_today == 1
      return render json: {msg: "Subscription limit reached.Upgrade membership to view more post"}, status: :unauthorized
    end


    # if membership==0 && viewed_articles_today==1 || membership==1 && viewed_articles_today==3
    #   || membership==2 && viewed_articles_today==5 || membership==3 && viewed_articles_today==10
    #   return render json: {msg: "Subscription limit reached.Upgrade membership to view more post"}, status: :unauthorized
    # end

    if @current_user.viewed_articles.find_by(params.require(:viewedarticle).permit(:article_id))
      return render json: {msg:viewed_articles_today}, status: :unprocessable_entity
    end
    @viewed_article = ViewedArticle.new(params.require(:viewedarticle).permit(:article_id))
    @viewed_article.user_id=@current_user.id
    if @viewed_article.save
      return render json: @viewed_article
    else
      render json: @viewed_article.errors.full_messages
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
