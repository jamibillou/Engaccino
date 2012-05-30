class UsersController < ApplicationController

  def index
    root_path = current_user.candidate? ? recruiters_path : candidates_path
    redirect_to root_path     
  end
  
  def linkedin_login
    client = LinkedIn::Client.new('z9dzn1xi6wkb','6W2HDTovO9TMOp8U')
    request_token = client.request_token(:oauth_callback => "http://#{request.host_with_port}/users/authenticate_login")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret
    redirect_to client.request_token.authorize_url 
  end
  
  def authenticate_login
    client = LinkedIn::Client.new('z9dzn1xi6wkb','6W2HDTovO9TMOp8U')
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      client.authorize_from_access(session[:atoken], session[:asecret])
    end
    @profile = client.profile(:fields => %w(first-name last-name headline positions educations skills))
    @connections = client.connections
    render :partial => 'connected_lk'
  end
end