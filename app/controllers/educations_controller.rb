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
    @education = Education.new params[:education]
    @education.candidate = current_user
    unless @education.save
      respond_to { |format| format.html { render :json => @education.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => 'create!' if request.xhr? } }
    end
  end
  
  def edit
    render :partial, 'edit_form', :locals => { :education => Education.find(params[:id]) }
  end
  
  def update
    @education = Education.find params[:id]
    unless @education.update_attributes params[:education]
      respond_to { |format| format.html { render :json => @education.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => 'update!' if request.xhr? } }
    end  
  end
  
  def destroy
    Education.find(params[:id]).destroy
    respond_to { |format| format.html { render :json => 'destroy!' if request.xhr? } }
  end
end
