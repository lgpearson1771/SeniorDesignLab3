Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :polls
  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root to: 'polls#login'
  get '/users/login/:id' => 'users#login'
  get '/users/error' => 'users#error'
  post '/users/login/:id' => 'users#check_login'
  get '/cancel/:id' => 'users#cancel'
  get '/users/logout/:id' => 'users#logout'


  post '/polls/:id/add_times' => 'polls#add_times'

  get '/polls/:id/invitees' => 'polls#invitees'

  resources :timeslots
  resources :invitees

  post '/polls/:id/publish' => 'polls#publish'
  post '/polls/:id/remind' => 'polls#remind'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  get 'poll_signup/:id' => 'users#poll'
  get 'users/show/:id' => 'users#show'
  post 'poll_signup/:id' => 'users#add_poll'
  get 'signup/:id' => 'users#signup'
  get 'signup_confirmation/:id' => 'users#signup_confirmation'
  get 'thanks' => 'users#thanks'


end
