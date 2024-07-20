Rails.application.routes.draw do
  mount FirebaseAuth::Engine => "/firebase_auth"
end
