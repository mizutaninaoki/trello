export default {
  setMessage({ commit }, message) {
    commit('setMessage', message)
  },
  clearMessage({ commit }) {
    commit('clearMessage')
  },
}
