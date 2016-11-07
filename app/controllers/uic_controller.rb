class UicController < ApplicationController
  protect_from_forgery with: :exception

  def login
    if cookies[:csig] && user_login? == true
      redirect_to :page_info
    end
  end

  def post_login
    name = params[:name]
    passwd = params[:passwd]
    res = {}
    flash = {}
    if name != "" && passwd != ""
      @uic_addr = ENV["uic_addr"]
      postparams = {
        name: name,
        password: passwd
      }
      http = Curl.post("http://#{@uic_addr}/api/v1/auth/login", postparams)
      if http.status =~ /200/
        res = JSON.parse(http.body)
        if res.has_key?("data")
          cookies[:cname] = res["data"]["name"]
          cookies[:csig] = res["data"]["sig"]
          flash = { :notice => "登入成功" }
        else
          flash = { :error => "找不到此帐号/密码, 请重试" }
        end
      end
    else
      flash[:error] = "帐号/密码 不可为空白"
    end
    redirect_to :login_page, :flash => flash
  end

  def logout
    cookies.delete :cname
    cookies.delete :csig
    redirect_to :login_page, :flash => {:notice => "已登出, 请重新登入"}
  end

end
