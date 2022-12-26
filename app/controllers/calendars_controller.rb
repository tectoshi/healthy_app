class CalendarsController < ApplicationController
  def index
    @nutrients = Nutrient.where(user_id: current_user)
  end
  
  def new
    @nutrient = Nutrient.new
  end

  def show
    @nutrient = Nutrient.find(params[:nutrient_id])
  end

  def create
    NUtrient.create(blog_parameter)
    redirect_to blogs_path
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    redirect_to blogs_path, notice:"削除しました"
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update(blog_parameter)
      redirect_to blogs_path, notice: "編集しました"
    else
      render 'edit'
    end
  end

  private

  def blog_parameter
    params.require(:blog).permit(:title, :content, :start_time)
  end
end
