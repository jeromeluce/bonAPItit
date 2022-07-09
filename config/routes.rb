Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :groups, only: [ :show, :create ] do
        member do
          post "restaurants_list"
          post "owner_restaurants_list" 
        end
      end
      resources :members, only: [ :show, :create ]
      post '/restaurants/:id/upvote_restaurant', to: 'restaurants#upvote_restaurant'
      post '/restaurants/:id/downvote_restaurant', to: 'restaurants#downvote_restaurant'
    end
  end
end
