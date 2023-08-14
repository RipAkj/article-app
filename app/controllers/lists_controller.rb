class ListsController < ApplicationController
  before_action :require_authentication

  def show
    @list=List.find(params[:id])
    render json: {list:@list,listItems:@list.list_items}, status: :ok
  end

  def index
    lists=@current_user.lists
    render json: lists, status: :ok
  end

  def create
    @list = List.new(params.require(:list).permit(:name))
    @list.user = @current_user
    if @list.save
      render json:@list, status: :created
    else
      render json: { errors:@list.errors.full_messages}, status: :no_content
    end
  end


  def update
    @list = List.find(params[:id])
    if @list.user != @current_user
      return render json: {msg: "you are not author of this list"}, status: :unauthorized
    end
    if @list.update(params.require(:list).permit(:name))
      render json: @list, status: :ok
      return
    else
      render json:{errors: @list.errors.full_messages}, status: :no_content
    end
  end

  def destroy
    @list = List.find(params[:id])
    if @list.user != @current_user
      return render json: {msg: "you are not author of list"}, status: :unauthorized
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
      @listNewItem=list.list_items
      @listNewItem.each do |item|
        @a=ListItem.new(list_id:@listNew.id,article_id:item.article_id)
        @a.save
      end
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
