class ListitemsController < ApplicationController
  before_action :require_authentication

  def create
    @listItem = ListItem.new(params.require(:listitem).permit(:article_id, :list_id))
    if @listItem.save
      render json:@listItem, status: :created
    else
      render json: { errors:@current_user }, status: :unprocessable_entity
    end
  end


  def destroy
    @lists = List.find(params[:id])
    @listItems = @lists.list_items
    @listItem=@listItems.select{ |item| item.article_id == params[:article_id]}
    if @lists.user != @current_user
      return render json: {msg: "you are not author of list item"}
    end
    if @listItem[0].destroy
      return render json: {msg: "given list item deleted succesfully"}, status: :ok
    else
      render json: {errors: @listItem.errors.full_messages}, status: :no_content
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
