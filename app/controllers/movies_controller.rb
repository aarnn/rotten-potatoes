class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings_to_show = params[:ratings] || session[:ratings] 
    
    if params[:ratings].nil? and params[:sort].nil? and !params[:usecookie].nil? and session[:set] == 1
      params[:ratings] = session[:saved]
      params[:sort] = session[:saved_sort]
      redirect_to(movies_path(params))
    end
    
    if params[:ratings].nil?
      @ratings_to_show = []
      @movies = Movie.all
    else
      @ratings_to_show = params[:ratings].keys
      @movies = Movie.where(rating: @ratings_to_show)
    end
    
    @movies = @movies.order(params[:sort])
    if params[:sort] == "title"
      @title = "hilite bg-warning"
    elsif params[:sort] == "release_date"
      @release = "hilite bg-warning"
    end
    
    session[:set] = 1
    session[:saved] = params[:rating]
    session[:saved_sort] = params[:sort]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
