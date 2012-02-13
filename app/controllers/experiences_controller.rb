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
      respond_to { |format| format.html { render :json => @experience.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => 'create!' if request.xhr? } }
    end    
  end
  
  def edit
    render :partial => 'edit_form', :locals => { :experience => Experience.find(params[:id]) }
  end
  
  def update
    @experience = Experience.find(params[:id])
    unless @experience.update_attributes(params[:experience])
      respond_to { |format| format.html { render :json => @experience.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => 'update!' if request.xhr? } }
    end  
  end
  
  def destroy
    experience = Experience.find(params[:id]) ; candidate = experience.candidate
    experience.destroy
    respond_to { |format| format.html { render :json => 'destroy!' if request.xhr? } }
  end
  
  def index
    @experiences = candidate.educations.order("start_year DESC, start_month DESC")
  end
end
