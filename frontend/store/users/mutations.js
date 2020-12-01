export default {
  // payload = ログインしているuserインスタンス
  setUser(state, payload) {
    state.id = payload.id
    state.lists = payload.lists
    state.email = payload.email
    state.nickname = payload.nickname
    state.user_image = payload.user_image
    state.user_image_url = payload.user_image.image_url
  },
  // payload = ログインしているuserインスタンス
  updateUser(state, payload) {
    state.id = payload.id
    state.lists = payload.lists
    state.email = payload.email
    state.nickname = payload.nickname
    state.user_image = payload.user_image
    state.user_image_url = payload.user_image_url
  },
}
