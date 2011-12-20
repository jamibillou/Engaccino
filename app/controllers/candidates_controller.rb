class CandidatesController < ApplicationController

  before_filter :authenticate,     :except => [:new, :create]
  before_filter :correct_user,     :only   => [:edit, :update]
  before_filter :completed_signup, :only   => [:index, :show]
  before_filter :admin_user,       :only   => [:destroy]
  before_filter :new_user,         :only   => [:new, :create]
  
  def index
    @candidates = Candidate.all
    set_title_javascripts(t('candidates.index.title'), ['users/index'])
  end
  
  def show
    @candidate = Candidate.find(params[:id])
    @title = "#{@candidate.first_name} #{@candidate.last_name}"
  end
  
  def new
    @candidate = Candidate.new
    set_title_javascripts(t('candidates.new.title'), ['candidates/new'])
  end
  
  def create
    @candidate = Candidate.new(params[:candidate])
    unless @candidate.save
      render_page(:new, t('candidates.new.title'), ['candidates/new'], :flash => { :message => error_messages(@candidate, [:email, :password]), :type => :error })
    else
      sign_in @candidate
      render_page(:edit, t('candidates.edit.complete_your_profile'), ['candidates/edit'], :id => @candidate)
    end
  end
  
  def edit
    @title = completed_signup? ? t('candidates.edit.title') : t('candidates.edit.complete_your_profile')
    @javascripts = ['candidates/edit']
  end

  def update
    unless @candidate.update_attributes(params[:candidate])
      title = completed_signup? ? t('candidates.edit.title') : t('candidates.edit.complete_your_profile')
      render_page(:edit, title, ['candidates/edit'], :flash => { :message => error_messages(@candidate), :type => :error }, :id => @candidate)
    else
      @title = "#{@candidate.first_name} #{@candidate.last_name}"
      flash[:success] = completed_signup? ? t('flash.success.profile_updated') : t('flash.success.welcome')
      @candidate.update_attributes(:profile_completion => 10) unless completed_signup?
      redirect_to @candidate
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
        @candidate = current_user
        redirect_to candidate_path(@candidate), :notice => t('flash.notice.already_registered')
      end
    end
    
end
