class BossInfoController < ApplicationController
  before_action :user_login?

  def platform
    @platforms = Host.select("platform").where("activate = 1 and platform != ''").distinct.map{|r| r.platform }.sort!
    render json: @platforms
  end

  def find_isp
    platform = params[:platform]
    @isp = []
    if platform != '0'
      @isp = Host.select("isp").where("activate = 1 and platform = '#{platform}'").distinct.map{|r| r.isp }.sort!
    end
    render json: @isp
  end

  def find_province
    platform = params[:platform]
    isp = params[:isp]
    @province = []
    if platform != '0' || isp != '0'
      sqlconn = Host.select("province").where("activate = 1")
      if platform != '0'
        sqlconn = sqlconn.where("platform = '#{platform}'")
      end
      if isp != '0'
        sqlconn = sqlconn.where("isp = '#{isp}'")
      end
      @province = sqlconn.distinct.map{|r| r.province }.sort!
    end
    render json: @province
  end

  def find_datacenter
    platform = params[:platform]
    isp = params[:isp]
    province = params[:province]
    @mplace = []
    if platform != '0' || isp != '0' || province != '0'
      sqlconn = Host.select("idc").where("activate = 1")
      if platform != '0'
        sqlconn = sqlconn.where("platform = '#{platform}'")
      end
      if isp != '0'
        sqlconn = sqlconn.where("isp = '#{isp}'")
      end
      if province != '0'
        sqlconn = sqlconn.where("province = '#{province}'")
      end
      @mplace = sqlconn.distinct.map{|r| r.idc }.sort!
    end
    render json: @mplace
  end

  def find_machine
    platform = params[:platform]
    isp = params[:isp]
    province = params[:province]
    datacenter = params[:datacenter]
    @mplace = []
    if platform != '0' || isp != '0' || province != '0'
      sqlconn = Host.select("hostname").where("activate = 1")
      if platform != '0' && platform != 'undefined'
        sqlconn = sqlconn.where("platform = '#{platform}'")
      end
      if isp != '0' && isp != '0'
        sqlconn = sqlconn.where("isp = '#{isp}'")
      end
      if province != '0'
        sqlconn = sqlconn.where("province = '#{province}'")
      end
      if datacenter != '0'
        sqlconn = sqlconn.where("idc = '#{datacenter}'")
      end
      @mplace = sqlconn.distinct.map{|r| r.hostname }
    end
    render json: @mplace
  end

end
