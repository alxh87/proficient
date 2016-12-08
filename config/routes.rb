Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'dashboard#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  post 'call-tracking/forward-call' => 'call_tracking#forward_call', as: :forward_call
  get 'statistics/leads_by_source' => 'statistics#leads_by_source', as: :leads_by_source
  get 'statistics/leads_by_city' => 'statistics#leads_by_city', as: :leads_by_city

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :lead_sources, only: [:create, :edit, :update]
  resources :available_phone_numbers, only: [:index]


  scope '/twilio' do
    resources :support_numbers
    resources :sales_numbers
  end
  get 'twilio/index' => 'callforward#index', as: 'callforward_index'
  post 'twilio/voice_receive' => 'twilio#voice_receive'
  match 'twilio/voice_menu' => 'twilio#voice_menu', via: [:get, :post], as: 'voice_menu'
  match 'twilio/voice_change' => 'twilio#voice_change', via: [:get, :post], as: 'voice_change'
  match 'twilio/voice_change/support' => 'twilio#voice_change_support', via: [:get, :post], as: 'support_change'
  match 'twilio/voice_change/sales' => 'twilio#voice_change_sales', via: [:get, :post], as: 'sales_change'
  post 'callforward/set_active_number' => 'callforward#set_active_number'
  

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
end
