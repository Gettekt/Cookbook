class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :edit]
  #before_action :verify, only: [:edit]

  # def verify
  #  if session["user_id"] == nil or params["id"].to_i != session["user_id"]
  #    redirect_to "/"
  #   else
  #    @user = User.find(session["user_id"])
  #   end
  # end
  # def log_in
  #  user = User.find_by_username(params["username"])
  #   if user and user.authenticate(params["password"])
  #    session["user_id"] =  user.id 
  #   elsif user
  #    flash.alert = "Invalid Password"
  #   else
  #     flash.alert = "Invalid Username"
  #   end 
  #   redirect_to '/'

  # end
  # def log_out
  #   session["user_id"] = nil
  #   redirect_to "/"
  # end

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user
  end

  # POST /users
  # POST /users.json
  def create
    binding.pry
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        allergen = params["user"]["allergen"]
        if allergen["name"] != "" and Ingredient.find_by_name(allergen["name"]) == nil 
          @ingredient = Ingredient.create({:name => allergen["name"] })
          Useringredient.create({:user_id => @user.id, :allergen_id => @ingredient.id})
        elsif allergen["name"] != ""
          @ingredient =  Ingredient.find_by_name(allergen["name"])
          Useringredient.create({:user_id => @user.id, :allergen_id => @ingredient.id})
        end
        if params["allergens"] != nil
          params["allergens"].each do |a|
            if Ingredient.find_by_name(a) == nil 
              @ingredient = Ingredient.create({:name => a})
              Useringredient.create({:user_id => @user.id, :allergen_id => @ingredient.id})
            else
              @ingredient = Ingredient.find_by_name(a)
              Useringredient.create({:user_id => @user.id, :allergen_id => @ingredient.id})
            end
          end
        end
        session["user_id"] = @user.id
        format.html { redirect_to '/', notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        allergen = params["user"]["allergen"]
        if allergen["name"] != "" and Ingredient.find_by_name(allergen["name"]) == nil 
          @ingredient = Ingredient.create({:name => allergen["name"] })
          Useringredient.create({:user_id => @user.id, :allergen_id => @ingredient.id})
        elsif allergen["name"] != ""
          @ingredient =  Ingredient.find_by_name(allergen["name"])
          Useringredient.create({:user_id => @user.id, :allergen_id => @ingredient.id})
        end
        if params["allergens"] != nil 
          params["allergens"].each do |a|
            if Ingredient.find_by_name(a) == nil 
              @ingredient = Ingredient.create({:name => a})
              Useringredient.create({:user_id => @user.id, :allergen_id => @ingredient.id})
            else
              @ingredient = Ingredient.find_by_name(a)
              Useringredient.create({:user_id => @user.id, :allergen_id => @ingredient.id})
            end
          end
        end
        if params["allergens_to_remove"] != nil
          params["allergens_to_remove"].each do |allergen|
            id =  Ingredient.find_by_name(allergen).id
            @user.useringredients.each do |useringredient|
              if useringredient.allergen_id == id
                useringredient.destroy
              end
            end
          end
        end
        format.html { redirect_to '/', notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end







  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :email)
    end
end
