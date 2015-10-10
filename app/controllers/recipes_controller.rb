class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)

    respond_to do |format|
      if @recipe.save 
        count = 1
        complete_directions = ""
        params["directions"].each do |direction|
          complete_directions += direction + "\n"
          count += 1
        end 
        @recipe.directions = complete_directions
        params["ingredients"].each_with_index do |ingredient, index|
          found = false
          Ingredient.all.each do |db_ingredient|
            if db_ingredient.name == ingredient
              @ingredient = db_ingredient
              Recipeingredient.create({:ingredient_id => @ingredient.id, :recipe_id => @recipe.id, :amount => params["amounts"][index]})
              found = true
            end
          end
          if found == false
            @ingredient = Ingredient.create({:name => ingredient})
            Recipeingredient.create({:ingredient_id => @ingredient.id, :recipe_id => @recipe.id, :amount => params["amounts"][index]})
          end
        end
        Userrecipe.create({:contribution_id => @recipe.id, :user_id => current_user.id})
        if params["tags"] != nil
          params["tags"].each do |tag|
            @tag = Tag.find_by_name(tag)
            Recipetag.create({:recipe_id => @recipe.id,:tag_id => @tag.id})
          end 
        end  
        @recipe.serves = params["serves"]
        @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        count = 1
        complete_directions = ""
        params["directions"].each do |direction|
          complete_directions += direction + "\n"
          count += 1
        end
        @ingredientnames = []
        @recipe.ingredients.each do |ingredient|
            @ingredientnames << ingredient.name 
        end
        params["ingredients"].each_with_index do |ingredient, index|
          if !@ingredientnames.include? ingredient and ingredient != ""
            found = false
            Ingredient.all.each do |db_ingredient|
              if db_ingredient.name == ingredient
                @ingredient = db_ingredient
                Recipeingredient.create({:ingredient_id => @ingredient.id, :recipe_id => @recipe.id, :amount => params["amounts"][index]})
                found = true
              end
            end
            if found == false
              @ingredient = Ingredient.create({:name => ingredient})
              Recipeingredient.create({:ingredient_id => @ingredient.id, :recipe_id => @recipe.id, :amount => params["amounts"][index]})
            end
          else 
            if ingredient != ""
              @ingredient = Ingredient.find_by_name(ingredient)
              @recipe.recipeingredients.each do |recipeingredient|
                if recipeingredient.ingredient_id == @ingredient.id
                  recipeingredient.update({:amount =>params["amounts"][index]})
                  recipeingredient.save
                end
              end
            end
          end 
        end
        @ingredientnames.each do |ingredient|
          if !params["ingredients"].include?(ingredient)
            @ingredient = Ingredient.find_by_name(ingredient)
            @recipe.recipeingredients.each do |recipeingredient|
              if recipeingredient.ingredient_id == @ingredient.id 
                recipeingredient.destroy
                if @ingredient.recipeingredients == nil
                  @ingredient.destroy
                end
              end
            end
          end
        end
        tags = []
        if params["tags"] != nil
          params["tags"].each do |tag|
            a = Tag.find_by_name(tag)
            tags << a
            if !@recipe.tags.include? a
              Recipetag.create({:recipe_id => @recipe.id, :tag_id => a.id })
            end
          end
        end
        @recipe.tags.each do |tag|
          if !tags.include? tag
            @recipe.recipetags.each do |recipetag|
              if recipetag.tag_id == tag.id 
                recipetag.destroy
              end
            end
          end
        end
        @recipe.serves = params["serves"]
        @recipe.name =params["name"]
        @recipe.directions = params["directions"].join("\n")
        @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end
  def update_rating
    #binding.pry
    require_user
    found = false
    @user = current_user
    @recipe = Recipe.find(params["recipe_id"])
    #binding.pry
    @total =0
    @recipe.ratings.each do |rating|
      @total += rating.value
    end 
    @user.ratings.each do |rating|
      if rating.recipe_id.to_i == params["recipe_id"].to_i
        @rating = rating
        found = true 
      end 
    end 
    if found == false
      @rating = Rating.create({:recipe_id => params["recipe_id"], :user_id => @user.id, :value => params["rating"].to_i})
      @recipe.rating = ((@total + params["rating"].to_i)/(@recipe.ratings.count.to_f))
    else
      @total -= @rating.value
      @rating.update({:value => params["rating"].to_i})
      @total += @rating.value
      @recipe.rating= ((@total.to_f)/@recipe.ratings.count) 
    end
    @recipe.save 
    if @user.ratings == []
      @first_time_set = params['rating']
    end 
    render :show 
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.permit(:name, :rating)
    end
end
