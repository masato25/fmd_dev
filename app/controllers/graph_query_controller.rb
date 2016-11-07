require 'time'

class GraphQueryController < ApplicationController
  def basic_query
    @graph_data = []
    hosts = params[:hosts]
    counters = params[:counters]
    compute_func = params[:func]
    start_time = params[:starttime]
    if start_time =~ /\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}/
      start_time = Time.strptime(start_time, '%Y-%m-%d %H:%M')
    else
      start_time = Chronic.parse('yesterday at 0:00')
    end
    end_time = params[:endtime]
    if end_time  =~ /\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}/
      end_time = Time.strptime(end_time, '%Y-%m-%d %H:%M')
    else
      Chronic.parse('today at 0:00')
    end
    if hosts != nil && counters != nil
      postform = "{#{hosts}}" + "#" + counters.gsub(".", "#")
      logger.info(postform)
      if compute_func != 'undefined' && compute_func != nil && compute_func != ''
        postform += "#" + compute_func
      end
      postparams = { "from": start_time.to_i,
        "until": end_time.to_i,
        "targets":[postform],
        "format":"json",
        "maxDataPoints":1920
      }
      http = Curl.post("http://#{api_server}/api/grafana/render_mutiple",postparams)
      if http.body =~ /endpoint/
        jsdata = JSON.parse(http.body_str)
        jsdata.each do |j|
          d = {}
          values = []
          d["endpoint"] = j["endpoint"]
          d["counter"] = j["counter"]
          j["Values"].each do |v|
            values.push([ v["timestamp"].to_i * 1000, v["value"] ])
          end
          d["data"] = values
          @graph_data.push(d)
        end
      end
    end
    render json: @graph_data
  end


  def order_query
    @host_data = []
    hosts = params[:hosts]
    counters = params[:counters]
    compute_func = params[:func]
    start_time = params[:starttime]
    if start_time =~ /\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}/
      start_time = Time.strptime(start_time, '%Y-%m-%d %H:%M')
    else
      start_time = Chronic.parse('yesterday at 0:00')
    end
    end_time = params[:endtime]
    if end_time  =~ /\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}/
      end_time = Time.strptime(end_time, '%Y-%m-%d %H:%M')
    else
      Chronic.parse('today at 0:00')
    end
    if hosts != nil && counters != nil
      postform = "{#{hosts}}" + "#" + counters.gsub(".", "#")
      logger.info(postform)
      if compute_func != 'undefined' && compute_func != nil && compute_func != ''
        postform += "#" + compute_func
      end
      postparams = { "from": start_time.to_i,
        "until": end_time.to_i,
        "targets":[postform],
        "format":"json",
        "maxDataPoints":1920
      }
      http = Curl.post("http://#{api_server}/api/grafana/render_mutiple",postparams)
      if http.body =~ /endpoint/
        jsdata = JSON.parse(http.body_str)
        jsdata.each do |j|
          @host_data.push(j["endpoint"])
        end
      end
    end
    render json: @host_data
  end
end
