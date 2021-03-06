require File.expand_path('../../lib/assets/routes_constraints', __FILE__)

Engaccino::Application.routes.draw do

  get 'sessions/new'
  get 'ajax/countries'
  get 'ajax/months'
  get 'ajax/companies'
  get 'ajax/recipients'
  get 'ajax/search'
    
  resources :candidates do
    resources :experiences do
      resources :companies
    end
    resources :educations do
      resources :schools
      resources :degrees do
        resources :degree_types
      end
    end
    resources :professional_skill_candidates do
      resources :professional_skills
    end
    resources :interpersonal_skill_candidates do
      resources :interpersonal_skills
    end
    resources :language_candidates do
      resources :languages
    end
    resources :certificate_candidates do
      resources :certificates
    end
  end
  
  resources :candidates, :experiences, :companies, :educations, :schools, :degree_types, :degrees, :professional_skill_candidates, :professional_skills, 
            :interpersonal_skill_candidates, :interpersonal_skills, :language_candidates, :languages, :certificate_candidates, :certificates
  resources :recruiters
  resources :messages, :search
  resources :sessions, :only => [:new, :create, :destroy]
  
  match 'candidates/refresh',         :to => 'candidates#refresh'
  match 'candidates/index/:act',      :to => 'candidates#index'
  match 'candidates/follow',          :to => 'relationships#create'
  match 'candidates/unfollow',        :to => 'relationships#destroy'
  
  match 'recruiters/refresh',         :to => 'recruiters#refresh'
  match 'recruiters/company_details', :to => 'recruiters#company_details'
  match 'recruiters/index/:act',      :to => 'recruiters#index'
  match 'recruiters/follow',          :to => 'relationships#create'
  match 'recruiters/unfollow',        :to => 'relationships#destroy'
  
  match 'companies/up_picture',       :to => 'companies#up_picture'
  
  match 'messages/conversation',      :to => 'messages#conversation'
  match 'messages/menu_top',          :to => 'messages#menu_top'
  match 'messages/menu_left',         :to => 'messages#menu_left'
  match 'messages/archive',           :to => 'messages#archive'
  match 'messages/card_messages',     :to => 'messages#card_messages'
  
  match 'search/index/:search',       :to => 'search#index'
  match 'search/index',               :to => 'search#index'
  
  match '/candidate_signup',          :to => 'candidates#new'
  match '/recruiter_signup',          :to => 'recruiters#new'
  match '/signin',                    :to => 'sessions#new'
  match '/signout',                   :to => 'sessions#destroy'
  
  match '/tour',                      :to => 'pages#tour'
  match '/pricing',                   :to => 'pages#pricing'
  match '/about',                     :to => 'pages#about'
  match '/contact',                   :to => 'pages#contact'
  
  match '/linkedin_signup',           :to => 'users#linkedin_login'
  match '/users/authenticate_login',  :to => 'users#authenticate_login'
  
  root :to => 'users#index',    :constraints => SingedIn.new(true)
  root :to => 'pages#overview', :constraints => SingedIn.new(false) 
end