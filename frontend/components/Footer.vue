<template>
  <div>
    <v-footer color="#000000" height="200">
      <v-container>
        <v-row>
          <v-col class="text-left white--text" cols="3">
            <h3 class="mb-3 font-weight-bold">メインメニュー</h3>
            <ul class="footer-list text-left">
              <li>
                <nuxt-link to="/">トップページ</nuxt-link>
              </li>
              <li><nuxt-link to="/auth/login">ログイン</nuxt-link></li>
              <li><nuxt-link to="#">お知らせ</nuxt-link></li>
            </ul>
          </v-col>
          <v-col class="text-left white--text" cols="3">
            <h3 class="mb-3 font-weight-bold">サポート</h3>
            <ul class="footer-list text-left">
              <li>
                <nuxt-link to="#">よくある質問</nuxt-link>
              </li>
              <li><nuxt-link to="#">ヘルプ</nuxt-link></li>
            </ul>
          </v-col>
          <v-col class="text-left white--text" cols="3">
            <h3 class="mb-3 font-weight-bold">ご利用に関して</h3>
            <ul class="footer-list text-left">
              <li>
                <nuxt-link to="#">利用規約</nuxt-link>
              </li>
              <li><nuxt-link to="#">プライバシーポリシー</nuxt-link></li>
            </ul>
          </v-col>
          <v-col class="text-right white--text font-weight-bold" cols="3">
            <h2>Trello</h2>
            <span>&copy; {{ new Date().getFullYear() }} Trello</span>
          </v-col>
        </v-row>
      </v-container>
    </v-footer>
  </div>
</template>

<style lang="scss" scoped>
.footer-list {
  list-style: none;
  padding: 0;
  a {
    font-size: 14px;
    font-weight: bold;
    color: #ffffff;
  }
}
</style>
