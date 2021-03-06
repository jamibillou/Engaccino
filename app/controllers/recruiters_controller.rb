class RecruitersController < ApplicationController
  
  before_filter :authenticate,           :except => [:new, :create]
  before_filter :new_user,               :only   => [:new, :create]
  before_filter :authorized, :signed_up, :only   => [:index, :show]
  before_filter :correct_user,           :only   => [:edit, :update]
  before_filter :not_signed_up,          :only   => :edit
  before_filter :admin_user,             :only   => :destroy
    
  def index
    case params[:act]
    when 'following'
      @recruiters = current_user.followed_users.where(:type => 'recruiter').paginate :page => params[:page], :per_page => 9
    when 'followers'
      @recruiters = current_user.followers.where(:type => 'recruiter').paginate :page => params[:page], :per_page => 9
    else
      @recruiters = Recruiter.paginate :page => params[:page], :per_page => 9
    end
    init_page :title => 'recruiters.index.title', :javascripts => 'users/index'
    respond_to do |format|
      format.html
      format.js { render :partial => 'recruiters' }
    end
  end
  
  def show
    @recruiter = Recruiter.find params[:id]
    @title = "#{@recruiter.first_name} #{@recruiter.last_name}"
    @messages = current_user.messages.where("author_id=#{params[:id]} OR recipient_id=#{params[:id]}").order("created_at DESC").limit(5)
    @message = Message.new
    init_page :javascripts => 'recruiters/show relationships'
  end
  
  def new
    @recruiter = Recruiter.new
    init_page :title => 'recruiters.new.title'
  end
  
  def create
    @recruiter = Recruiter.new params[:recruiter]
    unless @recruiter.save
      render_page :new, :title => 'recruiters.new.title'
    else
      sign_in @recruiter
      @recruiter.build_company
      render_page :edit, :id => @recruiter, :title => 'recruiters.edit.complete_your_profile', :javascripts => 'recruiters/edit'
    end
  end
  
  def edit
    @recruiter = Recruiter.find params[:id]
    @recruiter.build_company
    init_page :title => 'recruiters.edit.complete_your_profile', :javascripts => 'recruiters/edit'
  end
  
  def update
    @recruiter = Recruiter.find params[:id]
    @recruiter.update_attribute :company, Company.find_by_id(params[:recruiter][:company_attributes][:id]) unless request.xhr? || params[:recruiter][:company_attributes].nil?
    unless @recruiter.update_attributes params[:recruiter]
      @recruiter.build_company if no_company_submitted?
      init_page :title => 'recruiters.edit.complete_your_profile', :javascripts => 'recruiters/edit'
      respond_to do |format|
        format.html { render :json => error_messages(@recruiter) } if remotipart_submitted?
        format.html { flash[:error] = error_messages(@recruiter) ; render_page :edit, :id => @recruiter }
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
  
  def destroy
   Recruiter.find(params[:id]).destroy
   redirect_to recruiters_path, :flash => { :success => t('flash.success.user_destroyed') }
  end
  
  def refresh
    render :partial => 'recruiters/recruiter', :locals => { :recruiter => current_user }
  end
  
  def company_details
    render :partial => 'recruiters/company_details', :locals => { :company => Company.find_by_id(params[:id]), :recruiters => Recruiter.where(:company_id => params[:id]) }
  end
  
  private

    def no_company_submitted?
      params[:recruiter][:company_attributes].nil? || ( params[:recruiter][:company_attributes][:name].blank? && params[:recruiter][:company_attributes][:url].blank? && 
      params[:recruiter][:company_attributes][:city].blank? && params[:recruiter][:company_attributes][:country].blank? )
    end
end
