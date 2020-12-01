<template>
  <div class="mt-3">
    <v-card class="mt-5 mx-auto" max-width="600">
      <!-- 参照：https://qiita.com/tk07Sky/items/6a19704c1cbc8eb38027 -->
      <ValidationObserver v-slot="{ handleSubmit }">
        <v-form @submit.prevent="handleSubmit(loginWithAuthModule)">
          <v-container>
            <v-row justify="center">
              <p cols="12" class="mt-3 display-1 grey--text">ログイン</p>
            </v-row>
            <v-row justify="center">
              <v-col cols="12" md="10" sm="10">
                <validation-provider
                  v-slot="{ errors }"
                  rules="required"
                  name="メールアドレス"
                >
                  <v-text-field
                    v-model="email"
                    :error-messages="errors"
                    :success="valid"
                    label="メールアドレス"
                    required
                    filled
                  />
                </validation-provider>
              </v-col>
            </v-row>
            <v-row justify="center">
              <v-col cols="12" md="10" sm="10">
                <validation-provider
                  v-slot="{ errors }"
                  rules="required"
                  name="パスワード"
                >
                  <v-text-field
                    v-model="password"
                    type="password"
                    label="パスワード"
                  />
                  <p v-show="errors.length" class="help is-danger">
                    {{ errors[0] }}
                  </p>
                </validation-provider>
              </v-col>
            </v-row>
            <v-row justify="center">
              <v-col cols="12" md="10" sm="10">
                <v-btn block class="mr-4 blue white--text" type="submit">
                  ログイン
                </v-btn>
              </v-col>
            </v-row>
          </v-container>
        </v-form>
      </ValidationObserver>
    </v-card>
    <v-btn color="success" @click="sample()">aaaaaaaaaa</v-btn>
  </div>
</template>

<script>
import { ValidationObserver, ValidationProvider } from 'vee-validate'

export default {
  auth: false,
  middleware({ store, redirect }) {
    if (store.$auth.loggedIn) {
      // $nuxt.$toast.error('すでにログインしています')
      redirect('/MyPage/show')
    }
  },
  components: {
    ValidationObserver,
    ValidationProvider,
  },
  data() {
    return {
      valid: true,
      password: '',
      email: '',
    }
  },
  methods: {
    async loginWithAuthModule() {
      await this.$auth
        .loginWith('local', {
          data: {
            email: this.email,
            password: this.password,
          },
        })
        .then((response) => {
          this.$toast.success('ログインしました！')
          this.$router.replace({ path: '/MyPage/show' }).catch(() => {})
          return response
        })
        .catch((error) => {
          // ログインの際、エラーがあれば返ってきたエラーメッセージを表示させる
          // error.response.dataの中にエラーメッセージが配列で格納されている
          this.$store.commit('message/setMessage', error.response.data.errors)
          return error
        })
    },
    sample() {
      this.$axios
        .$get(`/users/sample`)
        .then((response) => {
          console.log('response data', response)
        })
        .catch((error) => {
          console.log('response error', error)
        })
    },
  },
}
</script>

<style scoped>
.is-danger {
  color: red;
}
</style>
