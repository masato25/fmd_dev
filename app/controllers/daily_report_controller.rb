require 'date'
class DailyReportController < ApplicationController
  before_action :user_login?
  
  def index
    @data1 = r2
    @data2 = r3
    @data3 = r4
    @e = Date.today.prev_day.to_time
  end

  def get_boss
    hosts = Host.where("exist = 1")
    boss = {}
    hosts.each{|b|
      boss[b["hostname"]] = b
    }
    boss
  end

  def count_intervel(evnets)
    counts = 0
    interval = 0
    timeTmp = 0
    evnets.each{|e|
      if e["status"] == 0 && timeTmp == 0
        timeTmp = e["timestamp"]
      elsif e["status"] == 1 && timeTmp != 0
        interval += e["timestamp"].to_i - timeTmp.to_i
        counts += 1
        timeTmp = 0
      end
    }
    if interval == 0 && counts == 0
      #set date the end as the endtime
      return [((timeTmp.to_i / 86400 + 1) * 86400) - timeTmp.to_i, false, 1]
    end
    return [interval/counts, (timeTmp == 0 ? true : false), counts]
  end

  def get_events
    events_tmp = get_info[:eventCases]
    events_tmp = events_tmp.group_by{|o| o[:id] }
    eve_ids =  events_tmp.keys
    k_keys = {}
    events_tmp.each{|k,v| k_keys[k] = v[0][:platform] }
    # s = Date.today.prev_day.prev_day.prev_day.prev_day.prev_day.to_time.to_i
    # e = Date.today.prev_day.prev_day.prev_day.prev_day.to_time.to_i
    s = Date.today.prev_day.prev_day.to_time.to_i
    e = Date.today.prev_day.to_time.to_i
    events = Event.where("event_caseId IN (\"#{eve_ids.join("\",\"")}\") AND timestamp >= FROM_UNIXTIME(#{s}) AND timestamp < FROM_UNIXTIME(#{e}) AND step = 1").order(timestamp: :asc)
    events = events.group_by{|o| o["event_caseId"] }.map{|k,v|
      interval, resovled, counts = count_intervel(v)
      platform = k_keys[k]
      {eid: k, platform: platform, interval: interval, resovled: resovled, counts: counts}
    }
    return events
  end
  def get_eve2
    render json: get_events
  end

  def get_info
    # s = Date.today.prev_day.prev_day.prev_day.prev_day.prev_day.to_time.to_i
    # e = Date.today.prev_day.prev_day.prev_day.prev_day.to_time.to_i
    s = Date.today.prev_day.prev_day.to_time.to_i
    e = Date.today.prev_day.to_time.to_i
    eventCases = EventCase.where("timestamp >= FROM_UNIXTIME(#{s}) and timestamp < FROM_UNIXTIME(#{e}) and (status in (\"OK\",\"PROBLEM\")) ").select("id,endpoint,metric,note")
    repo = []
    boss = get_boss()
    eventCases.each{|e|
      if(boss.has_key?(e["endpoint"]))
        bmap = boss[e["endpoint"]]
        repo = repo.push({
          id: e["id"],
          endpoint: e["id"],
          metric: e["metric"],
          note: e["note"],
          platform: bmap["platform"],
          idc: bmap["idc"],
          isp: bmap["isp"],
          province: bmap["province"]
        })
      end
    }
    return {eventCases: repo, filterBefore: eventCases.size, afterFilter: repo.size}
  end

  def r1
    res = get_info
    render json: res
  end

  def r2
    res = get_info
    res = res[:eventCases].group_by{|o| o[:metric] + " - " + o[:note]}.map{|k,y| { metric: k, count: y.size } }.sort_by{|o| - o[:count] }.take(10)
    res = res.group_by{|o| o[:metric]}.map{|k,v| [k,v[0]]}.inject({}) do |r, s|
      r.merge!({s[0] => s[1][:count]})
    end
    res
    # render json: res
  end

  def r3
    res = get_info
    res = res[:eventCases].group_by{|o| o[:platform] }.map{|k,y| { platform: k, count: y.size } }.sort_by{|o| - o[:count] }.take(5)
    res = res.group_by{|o| o[:platform]}.map{|k,v| [k,v[0]]}.inject({}) do |r, s|
      if s[0] == ""
        s[0] = "unknown"
      end
      r.merge!({s[0] => s[1][:count]})
    end
    res
    # render json: res
  end

  def r4
    res = get_events
    res = res.group_by{|o| o[:platform] }.map{|k,v|
      interval = 0
      counts = 0
      n_counts = 0
      got_alert = 0
      v.each{|o|
        if o[:resovled] == true && o[:counts] != 0
          interval += o[:interval]
          got_alert += o[:counts]
          counts += 1
        else
          n_counts += o[:counts]
        end
      }
      {platform: k, interval: (counts == 0 ? 0 : ((interval/counts).to_f / 60.to_f).round(1) ), alerts: "#{got_alert} / #{n_counts}"}
    }
    res.sort_by!{|s| - s[:alerts] }.sort_by!{|s| - s[:interval] }
    # render json: res
  end
end
