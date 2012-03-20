module RecruitersHelper
  
  def company_profile?
    params['controller'] == 'companies' && params['action'] == 'show'
  end
end
