namespace :identities do
  resources :registrations, only: :create do
    collection { post :confirmation, action: :confirm }
  end
end
