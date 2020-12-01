<template>
  <div>
    <v-app-bar fixed app color="#F38181" dark>
      <template v-if="this.$auth.loggedIn">
        <nuxt-link to="/MyPage/show">
          <v-toolbar-title
            color="#fff"
            class="font-weight-bold white--text"
            v-text="title"
          />
        </nuxt-link>
      </template>
      <template v-else>
        <nuxt-link to="/">
          <v-toolbar-title
            color="#fff"
            class="font-weight-bold white--text"
            v-text="title"
          />
        </nuxt-link>
      </template>
      <v-spacer />
      <template v-if="!this.$store.$auth.loggedIn">
        <v-btn
          rounded
          color="#ffffff"
          class="main-pink font-weight-bold px-10"
          depressed
          to="/auth/login"
          nuxt
          >ログイン</v-btn
        >
        <div class="ma-2"></div>
        <v-btn
          rounded
          color="#95e1d3"
          class="font-weight-bold px-10"
          dark
          depressed
          to="/auth/signup"
          nuxt
          >新規登録</v-btn
        >
      </template>
      <template v-else>
        <v-menu offset-y light>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              rounded
              class="font-weight-bold"
              color="#95e1d3"
              depressed
              v-bind="attrs"
              v-on="on"
            >
              ユーザーアイコン
            </v-btn>
          </template>
          <v-list class="text-center pointer pa-0">
            <v-list-item-title class="py-2"
              ><nuxt-link to="/users/edit" class="main-text-color"
                >アカウント設定</nuxt-link
              ></v-list-item-title
            >
            <v-divider></v-divider>
            <v-list-item-title class="py-2">よくある質問</v-list-item-title>
            <v-divider></v-divider>
            <v-list-item-title class="py-2" @click="logout"
              >ログアウト</v-list-item-title
            >
          </v-list>
        </v-menu>
      </template>
    </v-app-bar>
  </div>
</template>

<script>
export default {
  auth: false,
  data() {
    return {
      title: 'Trello',
    }
  },
  methods: {
    logout() {
      this.$auth.logout()
      this.$toast.success('ログアウトしました！')
      // ログアウト後はnuxt.config.jsに登録してある/MyPage/showに飛ばす様にしている
    },
  },
}
</script>

<style lang="scss" scoped>
#app {
  background-color: var(--v-background-base);
}

.main-pink {
  color: #f38181;
}

.main-blue {
  background-color: #95e1d3;
}

.main-text-color {
  color: #222222;
}

.pointer {
  &:hover {
    cursor: pointer;
  }
}
</style>
