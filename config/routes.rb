Rails.application.routes.draw do
 
  resources :users
  post '/auth/login', to: 'authentication#login'
  post '/auth/otp_confirmation', to: 'authentication#otp_confirmation'
  post '/auth/password_change', to: 'authentication#password_change'
  post '/auth/otp_confirmation_for_password_change', to: 'authentication#otp_confirmation_for_password_change'



  resources :items do
    member do
      patch 'soft_delete', to: 'items#soft_delete'
      patch 'restore', to: 'items#restore'
    end
  end

end
