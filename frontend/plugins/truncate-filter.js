import Vue from 'vue'

Vue.filter('TruncateText', function (value) {
  const length = 30
  const ommision = '...'
  if (value.length <= length) {
    return value
  }
  return value.substring(0, length) + ommision
})
