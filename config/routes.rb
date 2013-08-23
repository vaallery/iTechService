ItechService::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :users

  root to: 'dashboard#index'
  match 'dashboard' => 'dashboard#index', via: :get
  match 'become/:id' => 'dashboard#become', via: :get, as: 'become'
  match 'sign_in_by_card' => 'dashboard#sign_in_by_card', via: :get, as: 'sign_in_by_card'
  match 'actual_orders' => 'dashboard#actual_orders', via: :get
  match 'actual_tasks' => 'dashboard#actual_tasks', via: :get
  match 'ready_devices' => 'dashboard#ready_devices', via: :get
  match 'goods_for_sale' => 'dashboard#goods_for_sale', via: :get
  match 'reports' => 'dashboard#reports', via: :get
  match 'check_session_status' => 'dashboard#check_session_status', via: :get

  resources :users do
    get :duty_calendar, on: :member
    get :schedule, on: :collection
    get :add_to_job_schedule, on: :member
    get :staff_duty_schedule, on: :collection
    get :rating, on: :collection
    get :actions, on: :member
    get :finance, on: :member
    post :create_duty_day, on: :collection
    post :destroy_duty_day, on: :collection
  end
  resources :karmas, except: [:index, :show]
  match 'profile' => 'users#profile', via: :get
  match 'users/:id/update_wish' => 'users#update_wish', via: [:post, :put], as: 'update_wish_user'

  resources :clients do
    get :check_phone_number, on: :collection
    get :questionnaire, on: :collection
    get :autocomplete, on: :collection
    get :select, on: :member
  end

  resources :device_types, except: [:new] do
    post :reserve, on: :member
  end

  resources :tasks

  resources :locations, except: :show
  
  resources :devices do
    get :history, on: :member, defaults: { format: 'js' }
    get :device_type_select, on: :collection, defaults: { format: 'js' }
    get :device_select, on: :collection
    get :check_imei, on: :collection
    get :movement_history, on: :member
  end
  match 'check_device_status' => 'devices#check_status', via: :get
  match 'check_order_status' => 'orders#check_status', via: :get
  match 'devices/:device_id/device_tasks/:id/history' => 'devices#task_history', via: :get,
      as: :history_device_task, defaults: { format: 'js' }

  resources :device_tasks, only: [:edit, :update]

  resources :orders do
    get :history, on: :member, defaults: { format: 'js' }
    get :device_type_select, on: :collection
  end

  resources :infos

  resources :stolen_phones, except: :show

  resources :prices

  resources :announcements do
    post :close, on: :member
    post :close_all, on: :collection
  end
  match 'make_announce' => 'announcements#make_announce', via: :post
  match 'cancel_announce' => 'announcements#cancel_announce', via: :post
  #match 'close_all' => 'announcements#close_all', via: :post

  resources :comments

  resources :messages, path: 'chat', except: [:new, :edit, :update]

  resources :sales

  resources :sales_imports, only: [:new, :create]

  resources :gift_certificates do
    post :activate, on: :collection
    post :issue, on: :collection
    post :refresh, on: :member
    get :check, on: :collection
    get :scan, on: :collection
    get :history, on: :member, defaults: {format: 'js'}
  end

  resources :settings, except: [:show]

  resources :salaries

  resources :discounts

  resources :timesheet_days, path: 'timesheet', except: :show

  resources :categories, except: :show

  resources :features

  resources :contractors

  resources :feature_types

  resources :stores

  resources :products

  resources :installments

  resources :installment_plans

  wiki_root '/wiki'

  match '/delayed_job' => DelayedJobWeb, anchor: false

end
