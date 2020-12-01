<template>
  <v-row
    class="background-white"
    justify="center"
    align-content="center"
    no-gutters
  >
    <v-col class="text-center">
      <h2 class="main-pink">trelloのクローンアプリです。</h2>
      <v-btn color="info" class="font-weight-bold px-10" to="/auth/login" nuxt
        >ログインする</v-btn
      >
    </v-col>
  </v-row>
</template>

<script>
import Vue from 'vue'

export default Vue.extend({
  // トップページだけcontainerをfluidにしている
  layout: 'fluid',
  auth: false,
  middleware({ store, redirect }) {
    if (store.$auth.loggedIn) {
      redirect('/MyPage/show')
    }
  },
  methods: {
    logout() {
      this.$auth.logout()
      this.$toast.success('ログアウトしました！')
      this.$router.replace({ path: '/' })
    },
  },
})
</script>

<style lang="scss">
.main-pink {
  color: #f38181;
}

.main-blue {
  background-color: #95e1d3;
}

.background-white {
  background-color: #ffffff;
  min-height: 500px;
}
</style>
