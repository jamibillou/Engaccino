class CandidatesController < ApplicationController

  include ApplicationHelper
  include TimelineHelper

  respond_to :html, :json
  
  before_filter :authenticate,            :except => [:new, :create]
  before_filter :new_user,                :only   => [:new, :create]
  before_filter :recruiter_or_admin_user, :only   => :index
  before_filter :signed_up,               :only   => [:index, :show]
  before_filter :not_signed_up,           :only   => :edit
  before_filter :correct_candidate,       :only   => [:edit, :update]
  before_filter :admin_user,              :only   => :destroy
  
  def index
    @candidates = Candidate.all
    init_page :title => 'candidates.index.title', :javascripts => 'users/index'
  end
  
  def show
    @candidate = Candidate.find params[:id] ; @title = "#{@candidate.first_name} #{@candidate.last_name}"
    init_page :javascripts => 'candidates/show'
  end
  
  def new
    @candidate = Candidate.new
    init_page :title => 'candidates.new.title', :javascripts => 'candidates/new'
  end
  
  def create
    @candidate = Candidate.new params[:candidate]
    unless @candidate.save
      render_page :new, :title => 'candidates.new.title', :javascripts => 'candidates/new'
    else
      sign_in @candidate
      build_education ; build_experience
      render_page :edit, :id => @candidate, :title => 'candidates.edit.complete_your_profile', :javascripts => 'candidates/edit'
    end
  end
  
  def edit
    build_education ; build_experience
    init_page :title => 'candidates.edit.complete_your_profile', :javascripts => 'candidates/edit'
  end

  def update
    unless @candidate.update_attributes params[:candidate]
      init_page :title => 'candidates.edit.complete_your_profile', :javascripts => 'candidates/edit'
      build_education ; build_experience
      respond_to do |format|
        format.html { render :json => error_messages(@candidate) } if remotipart_submitted?
        format.html { render_page :edit, :id => @candidate }
        format.json { respond_with_bip @candidate }
      end
    else
      associate_schools_and_degrees
      respond_to do |format|
        format.json { render :json => 'success!' } if remotipart_submitted?
        format.html { @candidate.update_attributes :profile_completion => 5 ; redirect_to @candidate }
        format.json { respond_with_bip @candidate }
      end
    end
  end 

  def destroy
   Candidate.find(params[:id]).destroy
   redirect_to candidates_path, :flash => { :success => t('flash.success.candidate_destroyed') }
  end
  
  def refresh
    partial = params[:model].nil? ? "candidates/#{params[:partial]}" : "candidates/show_#{params[:model].to_s}s"
    render :partial => partial, :locals => { :candidate => current_user }
  end

  private
    
    def correct_candidate
      @candidate = Candidate.find params[:id]
      redirect_to current_user, :notice => t('flash.notice.other_user_page') unless current_user? @candidate
    end
    
    def signed_up
      redirect_to edit_recruiter_path(current_user), :notice => t('flash.notice.please_finish_signup') unless signed_up?
    end
    
    def recruiter_or_admin_user
      redirect_to root_path, :notice => t('flash.notice.recruiter_only_page') unless current_user.class.name.humanize == 'Recruiter' || current_user.admin
    end
end
