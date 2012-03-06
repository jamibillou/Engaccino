Engaccino::Application.routes.draw do

  get 'sessions/new'
  get 'ajax/countries'
  get 'ajax/months'
  get 'ajax/years'
  
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
  resources :sessions, :only => [:new, :create, :destroy]
  
  match 'candidates/refresh', :to => 'candidates#refresh'
  
  match '/candidate_signup',  :to => 'candidates#new'
  match '/recruiter_signup',  :to => 'candidates#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  
  match '/tour',    :to => 'pages#tour'
  match '/pricing', :to => 'pages#pricing'
  match '/about',   :to => 'pages#about'
  match '/contact', :to => 'pages#contact'
  
  root :to => 'candidates#index', :constraints => lambda { |request| request.cookies.key?('remember_token') }
  root :to => 'pages#overview',   :constraints => lambda { |request| !request.cookies.key?('remember_token') } 
    
end