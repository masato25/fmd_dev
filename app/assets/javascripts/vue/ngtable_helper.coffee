Vue.component 'ng-graph-grid', {
  template: '<div>
    <table class="table">
      <thead>
        <th>counter</th>
        <th>graph</th>
      </thead>
      <tbody>
        <tr v-for="(c, index) in countersmoke">
          <td>{{counters[index]}}</td>
          <td><div v-bind:id="hostname + c"></div></td>
        </tr>
      </tbody>
    </table>
  </div>'
  data: () ->
    cbase = ['cpu.idle','load.1min','net.if.in.bits/iface=eth_all', 'net.if.out.bits/iface=eth_all', 'mem.memfree.percent', 'disk.io.util.max','net.ping.gateway.loss','http.response.time','net.port.listen/port=80','net.port.listen/port=443']
    {
      # counter: 'cpu.idle,load.1min,disk.io.util.max,net.ping.gateway.loss,http.response.time,net.port.listen/port=80,net.port.listen/port=443',
      counters: cbase
      countersmoke: _.map(cbase, (d) ->
          return d.replace("/port=","").replace("/iface=","").replace(/\./g,"-")
        )
      loading: true
      mcolor:  ['#208371', '#a1308f', '#b8df34', '#3c3566', '#868143', '#d17031', '#125e2c', '#ab7f5b', '#1e5cb8']
    }
  props: ['hostname','start_time', 'end_time']
  created: ->
    this.fetchData()
  methods:
    fetchData: ->
      that = this
      start_time = $('.pickdate_start').val()
      end_time = $('.pickdate_end').val()
      url = '/graph/query_sparkline?counters=' + that.counters.join() + '&hosts=' + that.hostname + '&starttime=' + start_time + '&endtime=' + end_time
      $.getJSON(url, (resp) ->
        cdata = []
        if resp.length > 0
          _.each(resp, (d) ->
            fixedcounter = d.counter.replace("/port=","").replace("/iface=","").replace(/\./g,"-")
            indx = _.findIndex(that.counters, (c) ->
              return c == d.counter
            )
            if d.data.length != 0
              $("#" + d.endpoint + fixedcounter).sparkline(d.data,
                type: "line"
                width: '100%'
                height: '25'
                tooltipFormat: '<font color="white">{{y:val}}</font> [{{offset:date}}]'
                tooltipValueLookups: {
                  'date': d.date
                }
                lineColor: that.mcolor[indx]
                fillColor: that.mcolor[indx]
              )
            else
              $("#" + d.endpoint + fixedcounter).text("no data")
            return d
          )
        that.loading = false
      ).fail( ->
          console.log("failed - " + this.hostname)
      )
}
