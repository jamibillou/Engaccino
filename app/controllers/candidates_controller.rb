class CandidatesController < ApplicationController

  include TimelineHelper
  
  respond_to :html, :json, :js
  
  before_filter :authenticate,           :except => [:new, :create]
  before_filter :new_user,               :only   => [:new, :create]
  before_filter :authorized, :signed_up, :only   => [:index, :show]
  before_filter :correct_user,           :only   => [:edit, :update]
  before_filter :not_signed_up,          :only   => :edit
  before_filter :admin_user,             :only   => :destroy
  
  def index
    case params[:act]
    when 'following'
      @candidates = current_user.followed_users.where(:type => 'candidate').paginate :page => params[:page], :per_page => 9
    when 'followers'
      @candidates = current_user.followers.where(:type => 'candidate').paginate :page => params[:page], :per_page => 9
    else
      @candidates = Candidate.paginate :page => params[:page], :per_page => 9
    end
    init_page :title => 'candidates.index.title', :javascripts => 'users/index'
    respond_to do |format|
      format.html
      format.js { render :partial => 'candidates' }
    end
  end
  
  def show
    @candidate = Candidate.find params[:id]
    @message = Message.new
    @messages = current_user.messages.where("author_id=#{params[:id]} OR recipient_id=#{params[:id]}").order("created_at DESC").limit(5)
    @title = "#{@candidate.first_name} #{@candidate.last_name}"
    init_page :javascripts => 'candidates/show relationships'
  end
  
  def new
    @candidate = Candidate.new
    init_page :title => 'candidates.new.title'
  end
  
  def create
    @candidate = Candidate.new params[:candidate]
    unless @candidate.save
      render_page :new, :title => 'candidates.new.title'
    else
      sign_in @candidate
      build_education ; build_experience
      render_page :edit, :id => @candidate, :title => 'candidates.edit.complete_your_profile', :javascripts => 'candidates/edit'
    end
  end
  
  def edit
    @candidate = Candidate.find params[:id]
    build_education ; build_experience
    init_page :title => 'candidates.edit.complete_your_profile', :javascripts => 'candidates/edit'
  end

  def update
    @candidate = Candidate.find params[:id]
    unless @candidate.update_attributes params[:candidate]
      init_page :title => 'candidates.edit.complete_your_profile', :javascripts => 'candidates/edit'
      build_education ; build_experience
      respond_to do |format|
        format.js   { render :json => error_messages(@candidate) } if remotipart_submitted?
        format.html { render_page :edit, :id => @candidate }
        format.json { respond_with_bip @candidate }
      end
    else
      associate_schools_and_degrees
      respond_to do |format|
        format.js   { render :json => 'success!' } if remotipart_submitted?
        format.html { @candidate.update_attributes :profile_completion => 5 ; redirect_to @candidate }
        format.json { respond_with_bip @candidate }
      end
    end
  end 

  def destroy
   Candidate.find(params[:id]).destroy
   redirect_to candidates_path, :flash => { :success => t('flash.success.user_destroyed') }
  end
  
  def refresh
    partial = params[:model].nil? ? "candidates/#{params[:partial]}" : "candidates/show_#{params[:model].to_s}s"
    render :partial => partial, :locals => { :candidate => current_user }
  end    
end
