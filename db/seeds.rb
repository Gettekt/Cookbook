# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
allergens =  Ingredient.create([{name: 'Peanut'}, {name: 'Dairy'}, {name: 'Egg'}, {name: 'Tree-Nut'}, {name: 'Wheat'}, {name: 'Gluten'}, {name: 'Fish'},{name: 'Shellfish'}])
tags = Tag.create([{name: 'vegetarian'},{name: 'vegan'},{name: 'breakfast'},{name: 'lunch'},{name: 'dinner'},{name: 'dessert'}])