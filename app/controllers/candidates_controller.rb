class CandidatesController < ApplicationController

  before_filter :authenticate,     :except => [:new, :create]
  before_filter :correct_user,     :only   => [:edit, :update]
  before_filter :completed_signup, :only   => [:index, :show]
  before_filter :admin_user,       :only   => [:destroy]
  before_filter :new_user,         :only   => [:new, :create]
  
  def index
    @candidates = Candidate.all
    init_page(:title => 'candidates.index.title', :javascripts => 'users/index')
  end
  
  def show
    @candidate = Candidate.find(params[:id])
    @experiences = @candidate.experiences.order("year DESC")
    @educations = @candidate.educations.order("year DESC")
    @title = "#{@candidate.first_name} #{@candidate.last_name}"
  end
  
  def new
    @candidate = Candidate.new
    init_page(:title => 'candidates.new.title', :javascripts => 'candidates/new')
  end
  
  def create
    @candidate = Candidate.new(params[:candidate])
    unless @candidate.save
      render_page(:new, :title => 'candidates.new.title', :javascripts => 'candidates/new', :flash => { :error => error_messages(@candidate, :only => [:email, :password]) })
    else
      sign_in @candidate
      render_page(:edit, :id => @candidate, :title => 'candidates.edit.complete_your_profile', :javascripts => 'candidates/edit')
    end
  end
  
  def edit
    @candidate.experiences.build
    @candidate.educations.build
    @candidate.save
    init_page(:title => (completed_signup? ? 'candidates.edit.title' : 'candidates.edit.complete_your_profile'), :javascripts => 'candidates/edit')
  end

  def update
    #@company = @candidate.experiences.build ### PLANTE LES TESTS MAIS AU MOINS IL ESSAIE BIEN DE CONSTRUIRE LES AUTRES OBJETS, A APPROFONDIR, C'EST PLUS LOIN DU TOUT LA...
    #params[:candidate][:educations_attributes].values.each do |education|
    #  school = School.find_or_create_by_name(education[:school][:name])
    #  diploma = Diploma.find_or_create_by_label(education[:diploma][:name])
    #  diplomaType = DiplomaType.find_or_create_by_diploma_id_and_label(:diploma_id => diploma.id, 
    #                                                                   :label => education[:diploma][:diplomaType][:label])
    #  @candidate.educations << Education.new(:school_id => school.id, 
    #                                         :diploma_id => diploma.id,
    #                                         :label => education[:label],
    #                                         :year => education[:year])      
    #end
    
    settings = if completed_signup? then { :title => 'edit.title', :message => 'profile_updated' } else { :title => 'edit.complete_your_profile', :message => 'welcome' } end
    unless @candidate.update_attributes(params[:candidate])
      render_page(:edit, :id => @candidate, :title => "candidates.#{settings[:title]}", :javascripts => 'candidates/edit', :flash => { :error => error_messages(@candidate) })
    else
      @candidate.update_attributes(:profile_completion => 10) unless completed_signup?
      redirect_to @candidate, :flash => { :success => t("flash.success.#{settings[:message]}") }
    end
  end 

  def destroy
   Candidate.find(params[:id]).destroy
   redirect_to candidates_path, :flash => { :success => t('flash.success.candidate_destroyed') }
  end

  private

    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @candidate = Candidate.find(params[:id])
      redirect_to candidate_path(current_user), :notice => t('flash.notice.other_user_page') unless current_user?(@candidate)
    end
    
    def completed_signup
      @candidate = current_user
      redirect_to edit_candidate_path(@candidate), :notice => t('flash.notice.please_finish_signup') unless completed_signup?
    end
    
    def admin_user
      @candidate = current_user
      redirect_to candidate_path(@candidate), :notice => t('flash.notice.restricted_page') unless @candidate.admin
    end
    
    def new_user
      unless current_user.nil?
        redirect_to candidate_path(current_user), :notice => t('flash.notice.already_registered')
      end
    end
    
end
