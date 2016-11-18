Vue.component 'glink', {
  template: '<a v-bind:href="hosturl" target="_blank">{{host}}</a>'
  data: () ->
    {
      hosturl: ''
    }
  props: ['host']
  created: ->
    this.hosturl = this.genrul(this.host)
  methods:
    genrul: (host) ->
      return "http://grafana.owl.fastweb.com.cn/dashboard/db/status?server=" + host
}
