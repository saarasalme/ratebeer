# frozen_string_literal: true

Rails.application.routes.draw do
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resources :ratings, only: %i[index new create destroy]
  resource :session, only: [:new, :create, :destroy]
  resource :membership, only: [:new, :create, :destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'breweries#index'
  get 'kaikki_bisset', to: 'beers#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  
  # get 'ratings', to: 'ratings#index'
  # get 'ratings/new', to:'ratings#new'
  # post 'ratings', to: 'ratings#create'
end
