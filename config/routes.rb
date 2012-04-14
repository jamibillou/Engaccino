require File.expand_path('../../lib/assets/routes_constraints', __FILE__)

Engaccino::Application.routes.draw do

  get 'sessions/new'
  get 'ajax/countries'
  get 'ajax/months'
  get 'ajax/companies'
  get 'ajax/recipients'
  
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
  resources :messages
  resources :sessions, :only => [:new, :create, :destroy]
  
  match 'candidates/refresh',         :to => 'candidates#refresh'  
  match 'recruiters/refresh',         :to => 'recruiters#refresh'
  match 'recruiters/company_details', :to => 'recruiters#company_details'
  match 'companies/up_picture',       :to => 'companies#up_picture'
  match 'messages/conversation',      :to => 'messages#conversation'
  match 'messages/menu_top',          :to => 'messages#menu_top'
  match 'messages/menu_left',         :to => 'messages#menu_left'
  match 'messages/archive',           :to => 'messages#archive'
  
  match '/candidate_signup',  :to => 'candidates#new'
  match '/recruiter_signup',  :to => 'recruiters#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  
  match '/tour',    :to => 'pages#tour'
  match '/pricing', :to => 'pages#pricing'
  match '/about',   :to => 'pages#about'
  match '/contact', :to => 'pages#contact'
  
  root :to => 'users#index',    :constraints => SingedIn.new(true)
  root :to => 'pages#overview', :constraints => SingedIn.new(false)
    
end