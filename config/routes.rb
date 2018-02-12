Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root to: 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'
  get 'become/:id', to: 'dashboard#become', as: 'become'
  get 'sign_in_by_card', to: 'dashboard#sign_in_by_card'
  get 'actual_orders', to: 'dashboard#actual_orders'
  get 'actual_tasks', to: 'dashboard#actual_tasks'
  get 'actual_supply_requests', to: 'dashboard#actual_supply_requests'
  get 'ready_service_jobs', to: 'dashboard#ready_service_jobs'
  get 'check_session_status', to: 'dashboard#check_session_status'
  get 'print_tags', to: 'dashboard#print_tags'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  namespace :service do
    resources :job_templates
  end

  resources :departments
  resources :reports, only: [:index, :new, :create]

  resources :users do
    get :duty_calendar, on: :member
    get :schedule, on: :collection
    get :add_to_job_schedule, on: :member
    get :staff_duty_schedule, on: :collection
    get :rating, on: :collection
    get :actions, on: :member
    get :finance, on: :member
    get :bonuses, on: :member
    resources :faults, shallow: true, only: %i[index new create destroy]
    post :create_duty_day, on: :collection
    post :destroy_duty_day, on: :collection
  end

  resources :faults, only: %i[new create]

  resources :karmas do
    post :group, on: :collection, defaults: {format: 'js'}
    post :addtogroup, on: :collection, defaults: {format: 'js'}
    post :ungroup, on: :collection, defaults: {format: 'js'}
  end

  resources :karma_groups, except: [:new]

  get 'profile', to: 'users#profile'
  match 'users/:id/update_wish' => 'users#update_wish', as: 'update_wish_user', via: %i[post patch]
  resources :favorite_links, except: :show

  resources :clients do
    get :check_phone_number, on: :collection
    get :questionnaire, on: :collection
    get :autocomplete, on: :collection
    get :select, on: :member
    get :find, on: :member
    get :export, on: :collection
  end

  resources :client_categories

  resources :device_types, except: [:new] do
    post :reserve, on: :member
  end

  resources :tasks
  resources :locations, except: :show

  resources :service_jobs do
    get :history, on: :member, defaults: { format: 'js' }
    get :device_type_select, on: :collection, defaults: { format: 'js' }
    get :device_select, on: :collection
    get :check_imei, on: :collection
    get :movement_history, on: :member
    get :quick_search, on: :collection
    get :work_order, on: :member
    get :completion_act, on: :member
    post :create_sale, on: :member
    patch :set_keeper, on: :member, defaults: { format: 'js' }
    resources :device_notes, only: %i[index new create]
    scope module: :service_jobs do
      resource :subscription, only: %i[create destroy], format: :js
    end
  end

  namespace :substitute_phones do
    get :stock, to: 'stock#index', format: :js
  end

  resources :substitute_phones, shallow: true do
    resources :substitutions, module: :substitute_phones, only: %i[new create edit update]
  end

  resources :devices do
    get :autocomplete, on: :collection
    get :select, on: :member
  end

  get 'check_device_status' => 'service_jobs#check_status'
  get 'check_order_status' => 'orders#check_status'
  get 'service_jobs/:service_job_id/device_tasks/:id/history' => 'service_jobs#task_history', as: :history_device_task, defaults: { format: 'js' }

  resources :device_tasks, only: [:edit, :update]

  resources :orders do
    get :history, on: :member, defaults: { format: 'js' }
    get :device_type_select, on: :collection, defaults: {format: 'js'}
  end

  resources :infos
  resources :stolen_phones
  resources :prices

  resources :announcements do
    post :close, on: :member
    post :close_all, on: :collection
  end
  post 'make_announce' => 'announcements#make_announce'
  post 'cancel_announce' => 'announcements#cancel_announce'

  resources :comments
  resources :messages, path: 'chat', except: [:new, :edit, :update]

  resources :purchases do
    patch :post, on: :member
    patch :unpost, on: :member
    patch :print_barcodes, on: :member, defaults: {format: :pdf}
    patch :move_items, on: :member
    patch :revaluate_products, on: :member
  end

  resources :sales do
    patch :post, on: :member
    post :cancel, on: :member
    get :return_check, on: :member
    get :print_check, on: :member, defaults: {format: 'js'}
    get :print_warranty, on: :member
    post :attach_gift_certificate, on: :member, defaults: {format: 'js'}
    resources :payments
  end

  resources :sales_imports, only: [:new, :create]

  resources :gift_certificates do
    post :activate, on: :collection
    post :issue, on: :collection
    post :refresh, on: :member
    get :check, on: :collection
    get :scan, on: :collection
    get :find, on: :member
    get :history, on: :member, defaults: {format: 'js'}
  end

  resources :settings, except: [:show]
  resources :salaries
  resources :discounts, except: :show
  resources :timesheet_days, path: 'timesheet', except: :show
  resources :fault_kinds, except: :show
  resources :bonuses
  resources :bonus_types, except: :show
  resources :installments
  resources :installment_plans
  resources :client_categories
  resources :supply_categories
  resources :supply_reports

  resources :supply_requests do
    post :make_done, on: :member
    post :make_new, on: :member
  end
  resources :product_categories, except: :show
  resources :features, except: :show
  resources :contractors
  resources :feature_types, except: :show
  resources :top_salables
  resources :task_templates

  resources :stores do
    get :product_details, on: :member, defaults: {format: :js}
  end

  resources :products do
    get :category_select, on: :collection, defaults: {format: :js}
    get :choose, on: :collection, defaults: {format: :js}
    get :show_prices, on: :member, defaults: {format: :js}
    get :show_remains, on: :member, defaults: {format: :js}
    get :remains_in_store, on: :member, defaults: {format: :json}
    get :related, on: :member, defaults: {format: :js}
    post :select, on: :collection, defaults: {format: :js}
    get :find, on: :collection
    resources :items, except: [:show]
  end

  resources :items do
    get :remains_in_store, on: :member, defaults: {format: :json}
    get :autocomplete, on: :collection
  end

  resources :product_groups do
    get :select, on: :member
  end

  resources :option_types, except: :show

  resources :product_types do
    get :select, on: :member
    resources :option_values, only: [:index]
  end

  resources :price_types, except: :show
  resources :payment_types
  resources :banks, except: :show
  resources :installments
  resources :installment_plans
  resources :cash_operations, only: [:index, :new, :create]
  resources :cash_drawers
  resources :repair_groups
  resources :case_colors, except: :show
  resources :quick_tasks, except: :show
  resources :product_imports, only: [:new, :create]
  resources :case_pictures, only: [:index, :new, :create]
  resources :carriers, except: [:show]
  resources :media_orders
  resources :contacts_extractions, only: [:new, :create]

  resources :quick_orders do
    patch :set_done, on: :member
    get :history, on: :member
  end

  resources :trade_in_devices do
    get :print, on: :member
  end

  resources :cash_shifts, only: :show do
    post :close, on: :member
  end

  resources :revaluation_acts do
    patch 'post', on: :member
    patch 'unpost', on: :member
  end

  resources :movement_acts do
    patch 'post', on: :member
    patch 'unpost', on: :member
    get 'make_defect_sp', on: :collection
  end

  resources :deduction_acts do
    patch 'post', on: :member
  end

  resources :repair_services do
    get :choose, on: :collection, defaults: {format: :js}
    get :select, on: :member, defaults: {format: :js}
    patch :mass_update, on: :collection
  end

  resources :imported_sales, only: :index
  resources :sales_imports, only: [:new, :create]

  get 'receipts/new', as: :new_receipt
  get 'receipts/add_product'
  post 'receipts/print'

  namespace 'media_menu' do
    get '/', to: 'catalog#index'
    get 'items', to: 'items#index'
    get 'items/:id', to: 'items#show', as: 'item'
    resource 'order', only: %i[new create]
  end

  wiki_root '/wiki'

  match '/delayed_job' => DelayedJobWeb, anchor: false, via: %i[get post]
  mount API => '/'
  mount Ckeditor::Engine => '/ckeditor'
end
