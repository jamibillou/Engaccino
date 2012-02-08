class ExperiencesController < ApplicationController
  
  respond_to :json, :html
  
  def new
    @experience = Experience.new
    @experience.build_company
    render :partial => 'new_form'
  end
  
  def create
    @experience = Experience.new(params[:experience])
    @experience.candidate = current_user
    unless @experience.save
      respond_to do |format|
        format.html { render :json => @experience.errors, :status => :unprocessable_entity if request.xhr? }
      end
    else
      respond_to do |format|
        format.html { render :json => "Create ok" if request.xhr? }
      end      
    end    
  end
  
  def edit
    render :partial => 'edit_form', :locals => { :experience => Experience.find(params[:id]) }
  end
  
  def update
    @experience = Experience.find(params[:id])
    unless @experience.update_attributes(params[:experience])
      respond_to do |format|
        format.html { render :json => @experience.errors, :status => :unprocessable_entity if request.xhr? }
      end
    else
      respond_to do |format|
        format.html { render :json => "Everything is ok" if request.xhr? } 
      end        
    end  
  end
  
  def destroy
    experience = Experience.find(params[:id]) ; candidate = experience.candidate
    experience.destroy
    respond_to do |format|
      format.html { render :json => "Delete ok" if request.xhr? }
    end
  end
  
  def index
    @experiences = candidate.educations.order("start_year DESC, start_month DESC")
  end
end
