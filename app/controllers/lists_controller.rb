class ListsController < ApplicationController
  before_action :require_authentication

  def show
    @list=List.find(params[:id])
    render json:@list
  end

  def index
    lists=@current_user.lists
    render json:lists
  end

  def create
    @list = List.new(params.require(:list).permit(:name))
    @list.user = @current_user
    if @list.save
      render json:@list, status: :created
    else
      render json: { errors:@current_user }, status: :unprocessable_entity
    end
  end


  def update
    @list = List.find(params[:id])
    if @list.user != @current_user
      return render json: {msg: "you are not author of this list"}
    end
    if @list.update(params.require(:list).permit(:name))
      render json: @list, status: :ok
      return
    else
      render json:{errors: @list.errors.full_messages}
    end
  end

  def destroy
    @list = List.find(params[:id])
    if @list.user != @current_user
      return render json: {msg: "you are not author of list"}
    end
    if @list.destroy
      render json: {msg: "given list deleted succesfully"}, status: :ok
    else
      render json: {errors: @list.errors.full_messages}, status: :no_content
    end
  end

  def listShare
    @user=User.find(params[:user_id])
    list=List.find(params[:list_id])
    @listNew=List.new(name:list.name)
    @listNew.user=@user
    if @listNew.save
      render json: {msg:@listNew}, status: :ok
    else
      render json: {errors: @listNew.errors.full_messages}, status: :no_content
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
