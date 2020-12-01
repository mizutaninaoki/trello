<template>
  <div class="mt-3">
    <v-card class="mt-5 mx-auto" max-width="600">
      <v-form ref="form" v-model="valid" lazy-validation>
        <v-container>
          <v-row justify="center">
            <p cols="12" class="mt-3 display-1 grey--text">新規登録</p>
          </v-row>
          <v-row justify="center">
            <v-col cols="12" md="10" sm="10">
              <v-text-field v-model="email" label="Eメールアドレス" />
              <p class="caption mb-0" />
            </v-col>
          </v-row>
          <v-row justify="center">
            <v-col cols="12" md="10" sm="10">
              <v-text-field
                v-model="password"
                type="password"
                label="パスワード"
              />
            </v-col>
          </v-row>
          <v-row justify="center">
            <v-col cols="12" md="10" sm="10">
              <v-btn block class="mr-4 blue white--text" @click="SignUp">
                登録
              </v-btn>
            </v-col>
          </v-row>
        </v-container>
      </v-form>
    </v-card>
  </div>
</template>

<script>
export default {
  auth: false,
  middleware({ store, redirect }) {
    if (store.$auth.loggedIn) {
      // this.$toast.error('すでにログインしています')
      redirect('/MyPage/show')
    }
  },
  data() {
    return {
      valid: true,
      password: '',
      email: '',
    }
  },
  methods: {
    async SignUp() {
      const params = new URLSearchParams()
      params.append('email', this.email) // 渡したいデータ分だけappendする
      params.append('password', this.password)
      await this.$axios
        .$post('/auth', params)
        .then((res) => {
          // 新規登録成功したらそのままログインさせる
          this.loginWithAuthModule()
        })
        .catch((error) => {
          // 新規登録の際、エラーがあれば返ってきたエラーメッセージを表示させる
          const messages = error.response.data.errors
          this.$store.commit('message/setMessage', messages)
          return error
        })
      // this.$store.commit('posted')
      // this.$router.push('/')
    },
    // 新規登録後、そのままログインさせる
    loginWithAuthModule() {
      this.$auth
        .loginWith('local', {
          data: {
            email: this.email,
            password: this.password,
          },
        })
        .then((response) => {
          this.$router.replace({ path: '/MyPage/show' })
          this.$toast.success('新規登録しました！')
          return response
        })
        .catch((error) => {
          // ログインの際、エラーがあれば返ってきたエラーメッセージを表示させる
          const messages = error.response.data.errors
          this.$store.commit('message/setMessage', messages)
          return error
        })
    },
  },
}
</script>
