Vue.component 'netinfo-grid', {
  template: '<div class="col-sm-6">
    总速率: {{out_speend}} MB /
    bond模式: {{bond_mode}}
  </div>'
  data: () ->
    {
      counter: 'nic.default.out.speed,nic.bond.mode',
      out_speend: '未知',
      bond_mode: '未知'
    }
  props: ['hostname', 'start_time', 'end_time']
  created: ->
    that = this
    start_time = $('.pickdate_start').val()
    end_time = $('.pickdate_end').val()
    url = '/graph/basic_query?counters=' + that.counter + '&hosts=' + that.hostname + '&starttime=' + start_time + '&endtime=' + end_time
    $.getJSON(url, (resp) ->
      _.each(resp, (d) ->
        if d.counter == 'nic.default.out.speed'
          _.each(d.data, (o) ->
            if o[1] != null
              that.out_speend = _.floor(o[1])
            return o
          )
        else if d.counter == 'nic.bond.mode'
          _.each(d.data, (o) ->
            if o[1] != null && o[1] > 0
              that.bond_mode = _.floor(o[1])
            return o
          )
        return d
      )
    ).fail( ->
        console.log("failed - " + this.hostname)
    )
}
