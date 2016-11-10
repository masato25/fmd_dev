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
      postparams = {
        name: name,
        password: passwd
      }
      http = Curl.post("http://#{ENV["uic_addr"]}/api/v1/auth/login", postparams)
      http.connect_timeout = 60
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

  def bosslogin
    fastweb_session = cookies[:FASTWEB_CDNBOSS_SEESION]
    http = Curl.get(ENV["boss_info_api"]) do |conn|
      conn.headers['Cookie'] = "FASTWEB_CDNBOSS_SEESION=#{fastweb_session}"
    end
    http.connect_timeout = 60
    res = JSON.parse(http.body)
    if res["data"]
      data = res["data"]
      if !user_exsing?(data["username"])
        insert_data(data["username"], data["email"], data["realname"])
      end
      gen_session(data["username"], data["fastweb_session"])
      cookies[:cname] = data["username"]
      cookies[:csig] = fastweb_session
    end
    redirect_to :login_page
  end

  def user_exsing?(name)
    return User.where("name = '#{name}'").count > 0
  end

  def insert_data(name, email, cnname)
    user = User.new
    user.name = name
    user.cnname = cnname
    user.email = email
    user.role = 3
    user.created = Time.now
    user.save
  end

  def gen_session(name, boss_token)
    uid = User.where("name = '#{name}'").select("id").first
    if uid != nil
      find_session = Session.where("uid = #{uid} AND session = '#{boss_token}'")
      if !find_session
        session = Session.new
        session.uid = uid
        session.sig = boss_token
        session.expired = Time.now.to_i
        session.save
      end
    end
  end

end
