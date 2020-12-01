<template>
  <v-row class="background-white" no-gutters>
    <v-col class="main-pink">
      <h2>trello</h2>
    </v-col>
  </v-row>
</template>

<script>
import Vue from 'vue'

export default Vue.extend({
  // トップページだけcontainerをfluidにしている
  layout: 'fluid',
  auth: false,
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
}
</style>
