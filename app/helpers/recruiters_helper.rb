module RecruitersHelper
  
  def current_user_profile?(recruiter)
    current_user == recruiter && params[:action] == 'show'
  end
  
  def company_profile?
    params['controller'] == 'companies' && params['action'] == 'show'
  end
end
