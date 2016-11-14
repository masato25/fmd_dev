Highcharts.setOptions {
        global: {
            useUTC: false
        }
    }


Vue.component 'netagginfo-grid', {
  template: '<div class="col-sm-12">
    <div id="agggraph">
      <img src="/hourglass.svg" style="margin-top:10px">
    </div>
  </div>'
  data: () ->
    {
      counter: 'net.if.in.bits/iface=eth_all',
    }
  props: ['hostnames', 'start_time', 'end_time']
  created: ->
    that = this
    start_time = $('.pickdate_start').val()
    end_time = $('.pickdate_end').val()
    url = '/graph/basic_query?counters=' + that.counter + '&hosts=' + that.hostnames.join() + '&starttime=' + start_time + '&endtime=' + end_time + '&func=' +  encodeURI("{\"function\":\"sumAll\",\"aliasName\":\"sumAll\"}")
    $.getJSON(url, (resp) ->
      if resp.length > 0
        cdata = _.map(resp, (d) ->
          {
            type: 'line'
            name: d.counter
            data: d.data
          }
        )
      $('#agggraph').highcharts(
        chart:
          zoomType: 'x'
          height: 200
        title: text: false
        xAxis: type: 'datetime'
        yAxis:
          title:
            text: '速率'
        legend: enabled: true
        series: cdata
        tooltip:
          crosshairs:
            color: 'red'
            dashStyle: 'solid'
          shared: true
      )
    ).fail( ->
        console.log("failed - " + this.hostname)
    )
}
