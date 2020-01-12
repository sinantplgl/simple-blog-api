Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'authenticate', to: 'authentication#authenticate'
  get 'account/get', to: 'account#get', as: 'account'
  
  get 'posts/drafts', to: 'posts#drafts', as: 'post_drafts'
  get 'posts/drafts/:id', to: 'posts#show_draft', as: 'post_draft'
  resources :posts
  
end
