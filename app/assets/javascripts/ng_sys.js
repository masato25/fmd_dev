//= require vue/ngtable_helper

$(document).on("turbolinks:load", function () {
  //platforms
  var platforms = new Vue({
    el: '#ngsearchbar',
    data: {
      platforms: [],
      isp: [],
      provinces: [],
      nodes: [],
      datacenter: [],
      machines: [],
      selected_platform: 'undefined',
      selected_isp: 'undefined',
      selected_province: 'undefined',
      selected_node: 'undefined',
      selected_datacenter: 'undefined',
      err_message: '',
      time_start: '',
      time_end: '',
      loading: false,
      picked: 's0',
    },
    created: function() {
      var that
      that = this
      $.ajax({
        url: '/boss/platform',
        success: function(res) {
          that.platforms = _.chain(res).map(function(k){
            return {value: k, text: k}
          }).value()
        },
        error: function(data) {
          console.log("can not get list of platforms")
        }
      })
    },
    watch: {
      selected_platform: function(e){
        var that
        that = this
        that.isp = []
        that.province = []
        that.datacenter = []
        that.selected_isp = 'undefined'
        that.selected_province = 'undefined'
        that.selected_datacenter = 'undefined'
        $.ajax({
          url: '/boss/find_isp?platform=' + that.selected_platform,
          success: function(res) {
            that.isp = _.chain(res).map(function(k){
              return {value: k, text: k}
            }).value()
          },
          error: function(data) {
            console.log("can not get list of isp")
          }
        })
      },
      selected_isp: function(e){
        var that
        that = this
        that.provinces = []
        that.selected_province = 'undefined'
        $.ajax({
          url: '/boss/find_province?platform=' + that.selected_platform + '&isp=' + that.selected_isp,
          success: function(res) {
            that.provinces = _.chain(res).map(function(k){
              return {value: k, text: k}
            }).value()
          },
          error: function(data) {
            console.log("can not get list of province")
          }
        })
      },
      selected_province: function(e){
        var that
        that = this
        that.datacenter = []
        that.selected_datacenter = 'undefined'
        $.ajax({
          url: '/boss/find_datacenter?platform=' + that.selected_platform + '&isp=' + that.selected_isp + '&province=' + that.selected_province,
          success: function(res) {
            that.datacenter = _.chain(res).map(function(k){
              return {value: k, text: k}
            }).value()
          },
          error: function(data) {
            console.log("can not get list of province")
          }
        })
      }
    },
    methods: {
      query: function () {
        var that
        that = this
        that.machines = []
        start_time = $('.pickdate_start').val()
        end_time = $('.pickdate_end').val()
        that.err_message = ''
        if(that.selected_platform == 'undefined' || that.selected_isp == 'undefined'){
          that.err_message = '平台 和 ISP 为必选栏位,请检查'
        }else if(!start_time.match(/\d{4}-\d{2}-\d{2}\s+\d+:\d+/g) || !end_time.match(/\d{4}-\d{2}-\d{2}\s+\d+:\d+/g)){
          that.err_message = '搜寻时间格式不对或是未指定,请检查'
        }else{
          that.loading = true
          that.time_start = start_time
          that.time_end = end_time
          console.log("that.selected_platform -> " + that.selected_platform)
          console.log("that.selected_isp -> " + that.selected_isp)
          $.ajax({
            url: '/boss/find_machine?platform=' + that.selected_platform + '&isp=' + that.selected_isp + '&province=' + that.selected_province + '&datacenter=' + this.selected_datacenter,
            success: function(res) {
              that.machines = res
              that.loading = false
            },
            error: function(data) {
              console.log("can not get machines list")
              that.loading = false
            }
          })
        }
      },
      sort: function(counter, order, option) {
        var that
        that = this
        var machinetemplate = that.machines.join()
        that.machines = []
        that.loading = true
        that.picked = option
        func = '{"function":"orderByMetrics","filterBy":"' + counter + '","orderby":"' +  order + '"}'
        url = '/graph/order_query?counters=' + counter + '&hosts=' + machinetemplate + '&starttime=' + start_time + '&endtime=' + end_time + '&func=' + encodeURI(func)
        $.getJSON(url, function(resp){
          if(resp.length > 0){
            that.machines = resp
          }else {
            that.err_message = "发生不预期的错误, 请重新操作"
          }
          that.loading = false
        })
      },
      customtime: function(){
        //pending change custom_select to -> 自定义
      }
    }
  })

  $('.pickdate_start').datetimepicker({
    format: 'YYYY-MM-DD HH:mm'
  })
  $('.pickdate_end').datetimepicker({
    format: 'YYYY-MM-DD HH:mm'
  })

  $('#back-to-top').on('click', function (e) {
    e.preventDefault();
    $('html,body').animate({
      scrollTop: 0
    }, 700);
  });
})
