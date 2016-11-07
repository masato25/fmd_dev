class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def user_login?
    username = cookies[:cname]
    csig = cookies[:csig]
    if username != nil && csig != nil
      user_id = User.where("name = '#{username}'").select("id").first
      if user_id != nil
        session = Session.where("uid = #{user_id} and sig = '#{csig}'")
        if session != nil
          return true
        end
      end
    end
    redirect_to :login_page
  end

end
