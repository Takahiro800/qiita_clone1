# frozen_string_literal: true

Rails.application.routes.draw do
  root "homes#index"
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: 'api/v1/registrations'
      }
      resources :articles
    end
  end
end
