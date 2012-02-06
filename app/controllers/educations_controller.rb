class EducationsController < ApplicationController
  
  respond_to :json, :html
  
  def new
    @education = Education.new
    @education.build_school
    degree = @education.build_degree
    degree.build_degree_type
    render :partial => 'new_form'
  end
  
  def create
    @education = Education.new(params[:education])
    @education.candidate = current_user
    unless @education.save
      respond_to do |format|
        format.html { render :json => @education.errors, :status => :unprocessable_entity if request.xhr? }
      end
    else
      respond_to do |format|
        format.html { render :json => "Create ok" if request.xhr? }
      end      
    end
  end
  
  def edit
    render :partial, 'edit_form', :locals => { :education => Education.find(params[:id]) }
  end
  
  def update
    @education = Education.find(params[:id])
    unless @education.update_attributes(params[:education])
      respond_to do |format|
        format.html { render :json => @education.errors, :status => :unprocessable_entity if request.xhr? }
      end
    else
      respond_to do |format|
        format.html { render :json => "Edit ok" if request.xhr? }
      end        
    end  
  end
  
  def destroy
    education = Education.find(params[:id]) ; candidate = education.candidate
    education.destroy
    respond_to do |format|
      format.html { render :json => "Delete ok" if request.xhr? }
    end
  end
end
