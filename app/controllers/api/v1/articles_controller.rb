module Api
  module V1
class ArticlesController < ApiController
  def show
    render json:@article=Article.find(params[:id])
  end
  def index
    render json:@articles = Article.all
  end
  def new
    render json:@article = Article.new
  end
  def edit
    render json:@article = Article.find(params[:id])
  end
  def create
    #render plain: params[:article]
    @article = Article.new(params.require(:article).permit(:title, :description))
    @article.user = current_user
    if @article.save
      render json:"Article was created successfully"
    else
      render 'new'
    end
  end
  def update
    @article = Article.find(params[:id])
    if @article.update(params.require(:article).permit(:title, :description))
      render json:"Article was updated successfully"
      return
    else
      render json:"Article was not updated"
    end
  end
  def destroy
    @article = Article.find(params[:id]).destroy
  end
end
end
end
