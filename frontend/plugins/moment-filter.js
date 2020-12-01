import Vue from 'vue'
import moment from 'moment'

Vue.filter('DateNormal', function (value) {
  const date = moment(value)
  return date.format('YYYY/MM/DD(dd)')
})
