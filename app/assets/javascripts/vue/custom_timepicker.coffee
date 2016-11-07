moment = require('moment')

Vue.component 'custom-timepicker', {
  template: '<select class="form-control" v-model="selected_options" options="time_options">
    <option v-for="option in time_options" v-bind:value="option">
      {{ option }}
    </option>
  </select>'
  data: () ->
    {
      time_options: ['自定义', '最近30分钟', '最近1小时', '最近6小时', '最近12小时',
      '最近1天', '最近3天', '一周', '一个月', '三个月', '半年', '一年'],
      selected_options: '自定义'
    }
  watch: {
    selected_options: (picked) ->
      switch picked
        when '最近30分钟'
          this.time_convert(60*30*1000)
        when '最近1小时'
          this.time_convert(60*60*1000)
        when '最近6小时'
          this.time_convert(60*60*6*1000)
        when '最近12小时'
          this.time_convert(60*60*12*1000)
        when '最近1天'
          this.time_convert(60*60*24*1000)
        when '最近3天'
          this.time_convert(60*60*24*3*1000)
        when '一周'
          this.time_convert(60*60*24*7*1000)
        when '一个月'
          this.time_convert(60*60*24*30*1000)
        when '三个月'
          this.time_convert(60*60*24*90*1000)
        when '半年'
          this.time_convert(60*60*24*180*1000)
        when '一年'
          this.time_convert(60*60*24*365*1000)
  },
  methods: {
    time_convert: (cut_time) ->
      timecuted = +moment() - cut_time
      timeset = moment(timecuted).format('YYYY-MM-DD HH:mm')
      timenow = moment().format('YYYY-MM-DD HH:mm')
      $('.pickdate_start').val(timeset)
      $('.pickdate_end').val(timenow)
  }
}
