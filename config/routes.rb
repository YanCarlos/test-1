Rails.application.routes.draw do
  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      resources :artists, only: :index do
        member do
          resources :albums, only: :index
        end
      end

      resources :albums, only: [] do
        member do
          resources :songs, only: :index
        end
      end

      resources :genres, param: :genre_name, only: [] do
        member do
          get :random_song
        end
      end
    end
  end
end
