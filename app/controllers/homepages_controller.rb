class HomepagesController < ApplicationController
 require 'open-uri'
 before_action :require_user, only: [:homepage,:search]

 def homepage
   @user ||= User.find(session[:user_id]) if session[:user_id]
   render :homepage
 end
 def search
   @user ||= User.find(session[:user_id]) if session[:user_id]

   results = []
   Recipe.all.each do |recipe|
     results << recipe
   end
   Recipe.all.each do |recipe|
     if Levenshtein.distance(recipe.name.downcase, params['query'].downcase) > 2 and !recipe.name.downcase.include? params['query'].downcase and !params['query'].downcase.include? recipe.name.downcase
       results.delete(recipe)
     end
     tag_names = []
     recipe.tags.each do |tag|
       tag_names << tag.name
     end
     if params["tags"] != nil
       params["tags"].each do |tag|
         if !tag_names.include? tag and results.include? recipe
           results.delete(recipe)
         end
       end
     end
     if params["rating"] != nil and recipe.rating.to_i < params["rating"].to_i and results.include?(recipe)
       results.delete(recipe)
     end
     current_user.allergens.each do |allergen|
       recipe.ingredients.each do |ingredient|
         if (Levenshtein.distance("#{allergen.name}", "#{ingredient.name}") < 2 or ingredient.name.include? allergen.name or allergen.name.include? ingredient.name) and results.include? recipe
           results.delete(recipe)
         end
       end
     end
   end
   @recipes = results

    if results.length < 10
       query = params["query"].downcase.strip.gsub(" ", "%20")
       app_id = "6a884e5c"
       app_key = "9d871bcdbaed8221c46499cdd13f6cf5"
       search_path = "https://api.edamam.com/search?q=#{query}&app_id=#{app_id}&app_key=#{app_key}"


       @current_user ||= User.find(session[:user_id]) if session[:user_id]

       @current_user.allergens.each do |allergen|
          if ['peanut','tree-nut','fish','shellfish','dairy','egg','wheat','gluten','soy'].include? allergen.name.downcase
            search_path += ("&health=" + allergen.name.downcase + "-free")
          end
        end

        if params["tags"] != nil
          params["tags"].each do |tag|
            # Health Labels
            if ["vegetarian", "vegan", "paleo"].include? tag.downcase
              search_path += ("&health=" + tag.downcase)
            end
            # Diet Labels
            if ["high-protein", "low-carb", "low-fat", "balanced", "high-fiber", "low-sodium", "low-sugar", "sugar-conscious"].include? tag.downcase
              search_path += ("&diet=" + tag.downcase)
            end
          end
        end

       request = JSON.load(open(search_path))
       recipes = request["hits"]

       recipes.each do |recipe|
         recipe.each do |key, value|
           if key == "recipe"
             name = value["label"]
             image = value["image"]
             serves = value["yield"].ceil

             if !Recipe.find_by_name(name)
               Recipe.create(name: name, serves: serves, image: image, rating: 3)
             end
             if Recipe.find_by_name(name)
               value["dietLabels"].each do |dlabel|
                 if Tag.find_by_name(dlabel.downcase)
                   Recipetag.create(recipe_id: Recipe.find_by_name(name).id, tag_id: Tag.find_by_name(dlabel.downcase).id) if !Recipe.find_by_name(name).tags.find_by_id(Tag.find_by_name(dlabel.downcase).id)
                 end
               end

               value["healthLabels"].each do |hlabel|
                 if Tag.find_by_name(hlabel.downcase)
                   Recipetag.create(recipe_id: Recipe.find_by_name(name).id, tag_id: Tag.find_by_name(hlabel.downcase).id) if !Recipe.find_by_name(name).tags.find_by_id(Tag.find_by_name(hlabel.downcase).id)
                 end
               end

               value["ingredients"].each do |ingredient|
                 food = ingredient["food"]
                 amount = ingredient["quantity"].ceil
                 measure = ingredient["measure"] + "(s)"

                 amount_measure = amount.to_s + " " + measure

                 if !Ingredient.find_by_name(food)
                   Ingredient.create(name: food)
                   Recipeingredient.create(recipe_id: Recipe.find_by_name(name).id, ingredient_id: Ingredient.find_by_name(food).id, amount: amount_measure)
                 else
                   Recipeingredient.create(recipe_id: Recipe.find_by_name(name).id, ingredient_id: Ingredient.find_by_name(food).id, amount: amount_measure) if !Recipe.find_by_name(name).ingredients.find_by_id(Ingredient.find_by_name(food).id)
                 end
               end
               @recipes << Recipe.find_by_name(name)
             end
           end
         end
       end

       @recipes.each do |recipe|
         if Levenshtein.distance(recipe.name.downcase, params['query'].downcase) > 2 and !recipe.name.downcase.include? params['query'].downcase and !params['query'].downcase.include? recipe.name.downcase
           @recipes.delete(recipe)
         end
         tag_names = []
         recipe.tags.each do |tag|
           tag_names << tag.name
         end
         if params["tags"] != nil
           params["tags"].each do |tag|
             if !tag_names.include? tag and @recipes.include? recipe
               @recipes.delete(recipe)
             end
           end
         end
         if params["rating"] != nil and recipe.rating.to_i < params["rating"].to_i and @recipes.include?(recipe)
           @recipes.delete(recipe)
         end
         current_user.allergens.each do |allergen|
           recipe.ingredients.each do |ingredient|
             if (Levenshtein.distance("#{allergen.name}", "#{ingredient.name}") < 2 or ingredient.name.include? allergen.name or allergen.name.include? ingredient.name) and @recipes.include? recipe
               @recipes.delete(recipe)
             end
           end
         end
       end
     end

     render :homepage
 end
end
