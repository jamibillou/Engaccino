class RecruitersController < ApplicationController
  
  before_filter :authenticate,            :except => [:new, :create]
  before_filter :new_user,                :only   => [:new, :create]
  before_filter :candidate_or_admin_user, :only   => :index
  before_filter :signed_up,               :only   => [:index, :show]
  before_filter :not_signed_up,           :only   => :edit
  before_filter :correct_recruiter,       :only   => [:edit, :update]
  before_filter :admin_user,              :only   => :destroy
  
  def index
    @recruiters = Recruiter.all
    init_page :title => 'recruiters.index.title', :javascripts => 'recruiters/index'
  end
  
  def show
    @recruiter = Recruiter.find params[:id] ; @title = "#{@recruiter.first_name} #{@recruiter.last_name}"
    init_page :javascripts => 'recruiters/show'
  end
  
  def new
    @recruiter = Recruiter.new
    init_page :title => 'recruiters.new.title', :javascripts => 'recruiters/new'
  end
  
  def create
    @recruiter = Recruiter.new params[:recruiter]
    unless @recruiter.save
      render_page :new, :title => 'recruiters.new.title', :javascripts => 'recruiters/new', :flash => { :error => error_messages(@recruiter, :only => [:email, :password]) }
    else
      sign_in @recruiter
      @recruiter.build_company
      render_page :edit, :id => @recruiter, :title => 'recruiters.edit.complete_your_profile', :javascripts => 'recruiters/edit'
    end
  end
  
  def edit
    @recruiter.build_company
    init_page :title => 'recruiters.edit.complete_your_profile', :javascripts => 'recruiters/edit'
  end
  
  def update
    unless @recruiter.update_attributes params[:recruiter]
      init_page :title => 'recruiters.edit.complete_your_profile', :javascripts => 'recruiters/edit', :flash => { :error => error_messages(@recruiter) }
      respond_to do |format|
        format.html { render :json => error_messages(@recruiter) } if remotipart_submitted?
        format.html { render_page :edit, :id => @recruiter }
        format.json { respond_with_bip @recruiter }
      end
    else
      respond_to do |format|
        format.json { render :json => 'success!' } if remotipart_submitted?
        format.html { @recruiter.update_attributes :profile_completion => 5 ; redirect_to @recruiter }
        format.json { respond_with_bip @recruiter }
      end
    end
  end
  
  private
    
    def correct_recruiter
      @recruiter = Recruiter.find params[:id]
      redirect_to recruiter_path(current_user), :notice => t('flash.notice.other_user_page') unless current_user? @recruiter
    end
    
    def signed_up
      redirect_to edit_candidate_path(current_user), :notice => t('flash.notice.please_finish_signup') unless signed_up?
    end
    
    def candidate_or_admin_user
      redirect_to root_path, :notice => t('flash.notice.candidate_only_page') unless current_user.class.name.humanize == 'Candidate' || current_user.admin
    end
end
