require File.expand_path('../../lib/assets/routes_constraints', __FILE__)

Engaccino::Application.routes.draw do

  get "sessions/new"
  get "ajax/countries"

  resources :candidates do
    resources :experiences do
      resources :companies
    end
  end    
  
  resources :users, :companies, :experiences, :educations, :degree_types, :degrees, :schools, 
            :professional_skills, :interpersonal_skills, :professional_skill_candidates, :interpersonal_skill_candidates,
            :languages, :language_candidates
  resources :sessions, :only => [:new, :create, :destroy]
  
  match 'candidates/refresh',       :to => 'candidates#refresh'
  match 'candidates/showpart',      :to => 'candidates#showpart'
  match 'candidates/showblock',     :to => 'candidates#showblock'
  root                              :to => 'candidates#index', :constraints => SingedIn.new(true)
  
  match '/signup',  :to => 'candidates#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  
  match '/tour',    :to => 'pages#tour'
  match '/pricing', :to => 'pages#pricing'
  match '/about',   :to => 'pages#about'
  match '/contact', :to => 'pages#contact'
  root              :to => 'pages#overview',   :constraints => SingedIn.new(false)
    
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