class CandidatesController < ApplicationController

  include ApplicationHelper
  include TimelineHelper

  respond_to :html, :json
  
  before_filter :authenticate,       :except => [:new, :create]
  before_filter :new_user,           :only   => [:new, :create]
  before_filter :correct_user,       :only   => [:edit, :update]
  before_filter :admin_user,         :only   => [:destroy]
  before_filter :signed_up,          :only   => [:index, :show]
  
  def index
    @candidates = Candidate.all
    
    init_page :title => 'candidates.index.title', :javascripts => 'users/index'
  end
  
  def show
    @candidate = Candidate.find(params[:id])
    @title = "#{@candidate.first_name} #{@candidate.last_name}"
    init_page :javascripts => 'candidates/show'
  end
  
  def new
    @candidate = Candidate.new
    init_page :title => 'candidates.new.title', :javascripts => 'candidates/new'
  end
  
  def create
    @candidate = Candidate.new(params[:candidate])
    unless @candidate.save
      render_page :new, :title => 'candidates.new.title', :javascripts => 'candidates/new', :flash => { :error => error_messages(@candidate, :only => [:email, :password]) }
    else
      sign_in @candidate
      build_associations [:experiences, :educations], @candidate
      render_page :edit, :id => @candidate, :title => 'candidates.edit.complete_your_profile', :javascripts => 'candidates/edit'
    end
  end
  
  def edit
    build_associations [:experiences, :educations], @candidate
    init_page :title => (signed_up? ? 'candidates.edit.title' : 'candidates.edit.complete_your_profile'), :javascripts => 'candidates/edit'
  end

  def update
    update_completion_city    unless params[:candidate][:city].nil?
    update_completion_country unless params[:candidate][:country].nil?
    unless @candidate.update_attributes(params[:candidate])
      init_page :title => "candidates.edit.#{signed_up? ? 'title' : 'complete_your_profile'}", :javascripts => 'candidates/edit'
      respond_to do |format|
        format.html { render_page :edit, :id => @candidate, :flash => { :error => error_messages(@candidate) } }
        format.json { respond_with_bip @candidate }
      end
    else
      link_schools_degrees
      respond_to do |format|
        format.html { redirect_to @candidate, :flash => { :success => t("flash.success.#{signed_up? ? 'profile_updated' : 'welcome'}") } }
        format.json { respond_with_bip @candidate }
      end
    end
  end 

  def destroy
   Candidate.find(params[:id]).destroy
   redirect_to candidates_path, :flash => { :success => t('flash.success.candidate_destroyed') }
  end
  
  def refresh
    @candidate = current_user
    partial = params[:model].nil? ? "candidates/#{params[:partial]}" : "candidates/show_#{params[:model].to_s}s"
    render :partial => partial, :locals => { :candidate => @candidate }
  end

  private

    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @candidate = Candidate.find(params[:id])
      redirect_to candidate_path(current_user), :notice => t('flash.notice.other_user_page') unless current_user?(@candidate)
    end
    
    def signed_up
      redirect_to edit_candidate_path(current_user), :notice => t('flash.notice.please_finish_signup') unless signed_up?
    end
    
    def admin_user
      @candidate = current_user
      redirect_to candidate_path(@candidate), :notice => t('flash.notice.restricted_page') unless @candidate.admin
    end
    
    def new_user
      redirect_to candidate_path(current_user), :notice => t('flash.notice.already_registered') unless current_user.nil?
    end
    
    def update_completion_city
      @candidate.update_attributes :profile_completion => @candidate.profile_completion+5 if @candidate.city.empty? && !params[:candidate][:city].empty?
      @candidate.update_attributes :profile_completion => @candidate.profile_completion-5 if params[:candidate][:city].empty? && !@candidate.city.empty?
    end

    def update_completion_country
      @candidate.update_attributes :profile_completion => @candidate.profile_completion+5 if @candidate.country.empty? && !params[:candidate][:country].empty?
      @candidate.update_attributes :profile_completion => @candidate.profile_completion-5 if params[:candidate][:country].empty? && !@candidate.country.empty?
    end
end
