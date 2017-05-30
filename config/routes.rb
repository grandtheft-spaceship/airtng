Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "login/", to: "sessions#login", as: "login"
  get "logout/", to: "sessionslogout"
  post "login_attempt/", to: "sessions#login_attempt"

  resources :users, only: [:new, :create, :show]

  resourses :vacation_properties, path: "/properties"
  resources :reservations, only: [:new, :create]
  post "resevervations/incoming", to: "reservations#accept_or_reject", as: "incoming"

  root "main#index", as: "home"

end
