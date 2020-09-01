class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:edit, :update, :show]
  before_action :require_admin, except: [:index, :show]

  def show
    @ingredient_recipes = @ingredient.recipes.paginate(page: params[:page], per_page: 5)
  end

  def index
    @ingredients = Ingredient.paginate(page: params[:page], per_page: 5)
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      flash[:success] = 'You added a new ingredient'
      redirect_to ingredient_path(@ingredient)
    else
      render 'new'
    end
  end

  def edit
    
  end

  def update
    if @ingredient.update(ingredient_params)
      flash[:success] = 'You updated the ingredient'
      redirect_to ingredient_path(@ingredient)
    else
      render 'edit'
    end
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:name)
  end

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def require_admin
    if !logged_in? || (logged_in? && !current_chef.admin)
      flash[:danger] = 'You cannot perform this action'
      redirect_to ingredients_path
    end
  end
end
