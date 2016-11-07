# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Highcharts.setOptions {
        global: {
            useUTC: false
        }
    }

Vue.component 'graph-grid', {
  template: '<div v-bind:id="hostname">
  </div>'
  data: () ->
    {
      counter: 'net.if.out.bits/iface=eth_all,net.if.in.bits/iface=eth_all'
    }
  props: ['hostname', 'start_time', 'end_time']
  created: ->
    that = this
    start_time = $('.pickdate_start').val()
    end_time = $('.pickdate_end').val()
    url = '/graph/basic_query?counters=' + that.counter + '&hosts=' + that.hostname + '&datacenter=' + this.selected_datacenter + '&starttime=' + start_time + '&endtime=' + end_time
    $.getJSON(url, (resp) ->
      cdata = []
      if resp.length > 0
        cdata = _.map(resp, (d) ->
          {
            type: 'line'
            name: d.counter
            data: d.data
          }
        )
      $('#' + that.hostname).highcharts
        chart: zoomType: 'x'
        title: text: false
        xAxis: type: 'datetime'
        yAxis: title: text: '速率'
        legend: enabled: true
        series: cdata
    ).fail( ->
        console.log("failed - " + this.hostname)
    )
}
