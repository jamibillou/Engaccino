module RecruitersHelper
  
  def company_profile?
    params['controller'] == 'companies' && params['action'] == 'show'
  end
  
  def current_user_company_profile?(user)
    current_user == user && params['controller'] == 'companies' && params[:action] == 'show'
  end
end
