class SaveforlatersController < ApplicationController
  before_action :require_authentication

  def index
    save_for_laters=@current_user.save_for_laters
    render json:save_for_laters, status: :ok
  end

  def create
    @sfl = SaveForLater.new(article_id:params[:id])
    @sfl.user= @current_user
    #render json:params[:article_id]
    if @sfl.save
      render json:@sfl, status: :created
    else
      render json: { errors:@current_user }, status: :unprocessable_entity
    end
  end

  def destroy
    @sfl = @current_user.save_for_laters
    @sfl=@sfl.where(article_id:params[:id])
    if @sfl[0].destroy
      render json: {msg: "given save for later deleted succesfully"}, status: :ok
    else
      render json: {errors: @sfl.errors.full_messages}, status: :no_content
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
