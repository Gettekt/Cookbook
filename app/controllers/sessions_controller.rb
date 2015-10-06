class SessionsController < ApplicationController
	skip_before_action :verify_authenticity_token, :only => [:destroy]

    def new; end

    def create
      binding.pry
      @user = User.find_by_email(params[:session][:email])
      if @user && @user.authenticate(params[:session][:password])
        session[:user_id] = @user.id
        binding.pry
        redirect_to root_url
      else
        flash[:alert] = 'Failure'
        redirect_to login_path
      end
    end
    def destroy
      session[:user_id] = nil
      redirect_to root_url
    end
end