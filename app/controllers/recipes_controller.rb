class RecipesController < ApplicationController
  before_action :authenticate_user!,  expect:[:index]
  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end
# レシピモデルから空のモデルを持ってくる
  def new
    @recipe = Recipe.new
  end
# データベースに保存
  def create
    @recipe = Recipe.new(recipe_params)
    # 誰が投稿したのかを示す
    @recipe.user_id = current_user.id
    if @recipe.save
     redirect_to recipe_path(@recipe),notice:"投稿成功"
    else
      render :new
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    @user = User.new
    if @recipe.user != current_user
      redirect_to recipes_path, alert: "異なるメンバーからの操作です"
    end
  end
  
  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
    redirect_to recipe_path(@recipe),notice:"更新完了"
    else
      render :edit
    end
  end
  
  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    redirect_to recipes_path
  end

  private
  def recipe_params
    params.require(:recipe).permit(:title, :body, :image)
  end
end
