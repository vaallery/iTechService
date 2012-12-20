ItechService::Application.routes.draw do
  
  mount Ckeditor::Engine => '/ckeditor'

  resources :infos

  devise_for :users

  root to: 'dashboard#index'

  resources :users do
    get :duty_calendar, on: :member
  end
  match 'profile' => 'users#profile', via: 'get'
  match 'users/:id/update_wish' => 'users#update_wish', via: ['post', 'put'], as: 'update_wish_user'

  resources :clients do
    get :check_phone_number, on: :collection
  end

  resources :device_types, except: [:new, :edit]

  resources :tasks, except: :show

  resources :locations, except: :show
  
  resources :devices do
    get :autocomplete_device_type_name, on: :collection
    get :autocomplete_client_phone_number, on: :collection
    get :history, on: :member, defaults: {format: 'js'}
    get :device_type_select, on: :collection, defaults: {format: 'js'}
  end
  match 'devices/:device_id/device_tasks/:id/history' => 'devices#task_history', via: 'get',
      as: :history_device_task, defaults: {format: 'js'}
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
