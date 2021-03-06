Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/" => "uic#login", as: "login_page"
  get "/auth/boss" => "uic#bosslogin", as: "bosslogin"
  post "/auth/login" => "uic#post_login", as: "post_login"
  get "/auth/logout" => "uic#logout"
  get "/graph/sysinfo" => "sys_net_graph#page_info", as: 'page_info'

  #BossInfo
  get "/boss/platform" => "boss_info#platform"
  get "/boss/find_isp" => "boss_info#find_isp"
  get "/boss/find_province" => "boss_info#find_province"
  get "/boss/find_datacenter" => "boss_info#find_datacenter"
  get "/boss/find_machine" => "boss_info#find_machine"


  #Graph
  get "/graph/basic_query" => "graph_query#basic_query"
  get "/graph/order_query" => "graph_query#order_query"
  get "/graph/query_sparkline" => "graph_query#basic_query_for_sparkline"

  #NgGraph
  get "/graph/ngsysinfo" => "ng_sys#ng_info", as: 'ng_info'

  get "/daily_report" => "daily_report#index", as: 'daily_report'

end
