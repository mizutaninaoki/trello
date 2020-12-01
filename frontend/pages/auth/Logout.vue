<template>
  <div>
    <p>ログアウトしました！</p>
  </div>
</template>

<script>
export default {
  auth: false,
  middleware({ store, redirect }) {
    if (store.$auth.loggedIn) {
      redirect('/MyPage/show')
    }
  },
}
</script>
