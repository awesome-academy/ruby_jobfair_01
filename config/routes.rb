Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    default_url_options :host => "localhost:3000"
    root "static_pages#home"
    get "/careers/new", to: "careers#new"
    get "/careers/edit", to: "careers#edit"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/password_resets/new", to: "password_resets#new"
    get "password_resets/edit", to: "password_resets#edit"
    resources :users, :careers
    resources :account_activations, only: [:edit]
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :jobs
    resources :curriculum_vitaes
    resources :user_curriculum_vitaes
    match "*unmatched_route", to: "application#route_not_found", via: :all
  end
end
