class RevisionsController < ApplicationController
  before_action :require_authentication

  def show
    @revisions=@current_user.revisions
    render json: @revisions, status: :ok
  end

  def replace
    @revision=@current_user.revisions.find(params[:id])
    @article=Article.new(title:@revision.title,description:@revision.description,topic:@revision.topic)
    @article.user=@current_user
    if @article.save
      render json: { article: @article, message:'created successfully'}, status: :created
    else
      render json: { message:'not created'}, status: :unprocessable_entity
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
