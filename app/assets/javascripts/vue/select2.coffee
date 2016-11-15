Vue.component('select2', {
  twoWay: true
  props: ['options', 'value']
  data: () ->
    {}
  template: '<select>
    <slot></slot>
    </select>'
  mounted: () ->
    vm = this
    $(this.$el)
      .val(0)
      .select2({ data: this.options })
      .on('change',  () ->
        console.log("this value", this.value)
        vm.$emit('input', this.value)
      )
  watch:
    options: (options) ->
      $(this.$el).select2({ data: options })
    destroyed:  () ->
      $(this.$el).off().select2('destroy')
})
