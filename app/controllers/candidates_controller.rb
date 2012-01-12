class CandidatesController < ApplicationController

  include CandidatesHelper
  
  before_filter :authenticate,       :except => [:new, :create]
  before_filter :new_user,           :only   => [:new, :create]
  before_filter :correct_user,       :only   => [:edit, :update]
  before_filter :admin_user,         :only   => [:destroy]
  before_filter :signed_up,          :only   => [:index, :show]
  #before_filter :custom_validation,  :only   => [:update]
  
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
    build_associations
    init_page(:title => (signed_up? ? 'candidates.edit.title' : 'candidates.edit.complete_your_profile'), :javascripts => 'candidates/edit')
  end

  def update
    unless @candidate.update_attributes(params[:candidate])
      build_associations
      render_page(:edit, :id => @candidate, :title => "candidates.edit.#{signed_up? ? 'title' : 'complete_your_profile'}",
                                            :javascripts => 'candidates/edit',
                                            :flash => { :error => error_messages(@candidate) })
    else
      @candidate.update_attributes(:profile_completion => 10) unless signed_up?
      @candidate.educations.each do |education|
        school = education.school
        school.degrees.push(education.degree) unless school.degrees.include? education.degree
        school.save!
      end
      redirect_to @candidate, :flash => { :success => t("flash.success.#{signed_up? ? 'profile_updated' : 'welcome'}") }
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
    
    def signed_up
      redirect_to edit_candidate_path(current_user), :notice => t('flash.notice.please_finish_signup') unless signed_up?
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
    
    def custom_validation
      error = ""
      for i in 0..params[:candidate][:educations_attributes].count-1
        error += "empty degree line "+(i+1).to_s+"," if params[:candidate][:educations_attributes][i.to_s][:degree_attributes][:label].blank?
        error += "empty school line "+(i+1).to_s+"," if params[:candidate][:educations_attributes][i.to_s][:school_attributes][:label].blank?
      end
      redirect_to edit_candidate_path(current_user), :flash => {:error => error} unless error.blank?
    end
    
    def build_associations
      build_experience
      build_education
    end
    
    def build_experience
      @candidate.experiences.build.build_company
    end
    
    def build_education
      @education = @candidate.educations.build
      @education.build_school
      @degree = @education.build_degree
      @degree.build_degree_type
    end
    
end
