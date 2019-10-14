Rails.application.routes.draw do
  devise_for :users, :controllers => {
      :omniauth_callbacks =>  "users/omniauth_callbacks",
      :registrations => 'users/registrations',
      :sessions => 'users/sessions',
      :confirmations => 'users/confirmations',
      :passwords => 'users/passwords'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  root to: "auth_test#need_auth"  # ログイン後に遷移させるアクションを指定

  post 'v1/auth/is_logging_in', :controller =>'api/v1/auth', :action => 'is_logging_in'
  post 'v1/auth/has_role', :controller =>'api/v1/auth', :action => 'has_role'

  resources :users, :controller => 'api/v1/users', :path => 'v1/users'
  resources :user_role, :controller => 'api/v1/user_role', :path => 'v1/user_role'
end
