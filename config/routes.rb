DealmeIn::Application.routes.draw do
  
  get "proposals/latest"
  get "proposals/latest_invitation"
  
  get "rsvp/:proposal_id/:rsvp", :controller => "invitations", :action => "update"
  
  get "main/index"
  
  get "main/connected"
  
  get "main/deals"
  
  get "main/deal_detail/:deal_id", :controller => "main", :action => "deal_detail"

  get "main/test_requests"
  
  get "main/deals_layout"
  
  get "facebook_requests_dialog_callback/:data", :controller => "main", :action => "facebook_requests_dialog_callback"
  
  get "facebook_auth_response_callback/:data", :controller => "main", :action => "facebook_auth_response_callback"

  root :to => 'main#deals'
  
  resources :locations
  resources :deals
  resources :invitations
  resources :proposals
  resources :users

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
  # match ':controller(/:action(/:id(.:format)))'
end
