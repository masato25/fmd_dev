class BossInfoController < ApplicationController
  before_action :user_login?

  def platform
    @platforms = Host.select("platform").where("activate = 1").distinct.map{|r| r.platform }
    render json: @platforms
  end

  def find_isp
    platform = params[:platform]
    @isp = []
    if platform != nil
      @isp = Host.select("isp").where("activate = 1 and platform = '#{platform}'").distinct.map{|r| r.isp }
    end
    render json: @isp
  end

  def find_province
    platform = params[:platform]
    isp = params[:isp]
    @province = []
    if platform != nil || isp != nil
      sqlconn = Host.select("province").where("activate = 1")
      if platform != nil
        sqlconn = sqlconn.where("platform = '#{platform}'")
      end
      if isp != nil
        sqlconn = sqlconn.where("isp = '#{isp}'")
      end
      @province = sqlconn.distinct.map{|r| r.province }
    end
    render json: @province
  end

  def find_datacenter
    platform = params[:platform]
    isp = params[:isp]
    province = params[:province]
    @mplace = []
    if platform != nil || isp != nil || province != nil
      sqlconn = Host.select("idc").where("activate = 1")
      if platform != nil
        sqlconn = sqlconn.where("platform = '#{platform}'")
      end
      if isp != nil
        sqlconn = sqlconn.where("isp = '#{isp}'")
      end
      if province != nil
        sqlconn = sqlconn.where("province = '#{province}'")
      end
      @mplace = sqlconn.distinct.map{|r| r.idc }
    end
    render json: @mplace
  end

  def find_machine
    platform = params[:platform]
    isp = params[:isp]
    province = params[:province]
    datacenter = params[:datacenter]
    @mplace = []
    if platform != nil || isp != nil || province != nil
      sqlconn = Host.select("hostname").where("activate = 1")
      if platform != nil && platform != 'undefined'
        sqlconn = sqlconn.where("platform = '#{platform}'")
      end
      if isp != nil && isp != 'undefined'
        sqlconn = sqlconn.where("isp = '#{isp}'")
      end
      if province != nil && province != 'undefined'
        sqlconn = sqlconn.where("province = '#{province}'")
      end
      if datacenter != nil && datacenter != 'undefined'
        sqlconn = sqlconn.where("idc = '#{datacenter}'")
      end
      @mplace = sqlconn.distinct.map{|r| r.hostname }
    end
    render json: @mplace
  end

end
