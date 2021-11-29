class FavoritesController < ApplicationController

    def index
        favorites = Favorite.all
        render json: favorites
    end

    def create
        restaurant = Restaurant.find(params[:restaurant_id])
        user = logged_in_user
        favorite = Favorite.create(restaurant:restaurant , user: user )
    end

    def destroy
        favorite = Favorite.find(params[:id])
        favorite.destroy
        render json: {message: "Successfully removed favorite"}
    end

     
    
    
end