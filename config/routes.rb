FirebaseAuth::Engine.routes.draw do
  get 'login', to: 'auth#new_login'
  post 'login', to: 'auth#create_login'
  get 'signup', to: 'auth#new_signup'
  post 'signup', to: 'auth#create_signup'
  delete 'logout', to: 'auth#destroy'
end
