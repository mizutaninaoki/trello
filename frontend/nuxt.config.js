import colors from 'vuetify/es5/util/colors'

const config = {
  mode: 'spa',
  /*
   ** Headers of the page
   */
  head: {
    titleTemplate: '%s - ' + process.env.npm_package_name,
    title: process.env.npm_package_name || '',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      {
        hid: 'description',
        name: 'description',
        content: process.env.npm_package_description || '',
      },
    ],
    link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }],
  },
  /*
   ** Customize the progress-bar color
   */
  loading: { color: '#fff' },
  /*
   ** Global CSS
   */
  css: ['@/assets/scss/base.scss'],
  /*
   ** Plugins to load before mounting the App
   */
  plugins: [
    { src: '~/plugins/axios.js', ssr: false },
    { src: '~/plugins/vee-validate', ssr: false },
    { src: '~/plugins/routerOption.js', ssr: false },
    { src: '~/plugins/moment-filter', ssr: false },
    { src: '~/plugins/truncate-filter', ssr: false },
    { src: '~plugins/direct-edit', ssr: false },
  ],
  /*
   ** Nuxt.js dev-modules
   */
  buildModules: [
    // Doc: https://github.com/nuxt-community/eslint-module
    '@nuxtjs/eslint-module',
    '@nuxtjs/vuetify',
  ],
  /*
   ** Nuxt.js modules
   */
  modules: [
    // Doc: https://axios.nuxtjs.org/usage
    '@nuxtjs/axios',
    // Doc: https://github.com/nuxt-community/dotenv-module
    '@nuxtjs/dotenv',
    '@nuxtjs/proxy', // 追記
    '@nuxtjs/auth', // ログイン機能
    '@nuxtjs/toast',
    'nuxt-fontawesome',
    ['@nuxtjs/moment', ['ja']],
  ],
  // toasted のデフォルト挙動設定
  toast: {
    // 右上にtoastを表示
    position: 'top-right',
    // 特に指定しなくても3秒で消えるように設定
    duration: 3000,
    // toastのテーマ
    theme: 'toasted-primary',
  },
  fontawesome: {
    imports: [
      {
        set: '@fortawesome/free-solid-svg-icons',
        icons: ['fas'],
      },
    ],
  },
  /*
   ** Axios module configuration
   ** See https://axios.nuxtjs.org/options
   */
  /// //////////ログインに必要な設定//////////////////////////////////////////////
  axios: {
    // host: 'localhost',
    // port: 80,
    // baseURL: 'http://localhost:3333/api/v1',
    // baseURL: 'http://localhost/api/v1',
    // proxy: true,
    // baseURL: process.env.NODE_ENV === "production" ? "https://backend.mizutaninaoki.com/api/v1" : "http://localhost/api/v1"
    baseURL: process.env.NODE_ENV === "production" ? "https://backend.mizutaninaoki.com/api/v1" : "http://localhost/api/v1"
    // baseURL: "https://mizutaninaoki.com/api/v1"
  },
  auth: {
    redirect: {
      // ユーザの状態（ログインしているか否か）でどこにリダイレクトするかなどを設定します。
      login: '/auth/login', // ユーザが未ログイン時、ログインしていないとアクセスできないページにアクセスした際のリダイレクトURLです。
      logout: '/auth/l  ogin', // ユーザがログアウトした時のリダイレクトURLです。
      callback: false, // Oauth認証等で必要となるコールバック用URLです。今回はOauth認証は使わないのでfalseです。
      home: false, // ログイン成功後にリダイレクトするURLです。Login.vueで/MyPage/showにリダイレクトさせているため、ここはfalseにしておく。
    },
    strategies: {
      // Auth Moduleのどの認証ロジックを使うかを指定します。JWTとCookieを使うlocalと、OAuthを使うsocialの２種類があります。今回はJWTを使って認証を行うので、localです。
      local: {
        endpoints: {
          // どのメソッドが呼ばれた際にRails(Go) APIのどのエンドポイントに飛ばすかを指定します。（logoutはログアウト用のAPIエンドポイントを指定しますが、今回は実装しないのでfalseです。同様にユーザ情報を取得するためのuserもfalseにしています。)
          // login: { url: 'login', method: 'post', propertyName: 'token' },
          login: {
            url: '/auth/sign_in',
            method: 'post',
            propertyName: false,
          },
          user: {
            url: '/users/me',
            method: 'get',
            propertyName: false,
          },
          logout: false,
        },
      },
    },
  },
  // これでログインしている状態で/loginにアクセスしようとしてもホームにリダイレクトされるはずです。（
  router: {
    middleware: ['auth'],
  },
  /// /////////////////////////////////////////////////////////////////////////
  /*
   ** vuetify module configuration
   ** https://github.com/nuxt-community/vuetify-module
   */
  vuetify: {
    vuetify: {
      customVariables: ['~/assets/variables.scss'],
      // パッケージの中で必要なソースコードのみをビルドパッケージに含めて、使わなかったソースコードは除外してくれます。
      treeShake: true,
      theme: {
        themes: {
          dark: {
            primary: colors.blue.darken2,
            accent: colors.grey.darken3,
            secondary: colors.amber.darken3,
            info: colors.teal.lighten1,
            warning: colors.amber.base,
            error: colors.deepOrange.accent4,
            success: colors.green.accent3,
            aaa: '#F38181',
          },
          light: {
            primary: colors.blue.darken2,
            accent: colors.grey.darken3,
            secondary: colors.amber.darken3,
            info: colors.teal.lighten1,
            warning: colors.amber.base,
            error: colors.deepOrange.accent4,
            success: colors.green.accent3,
            'custom-color-one': '#F38181',
          },
        },
        options: {
          customProperties: true,
        },
      },
    },
  },
  /*
   ** Build configuration
   */
  build: {
    /*
     ** You can extend webpack config here
     */
    extend(config, ctx) {},
    // validateで以下の記述が必要
    transpile: ['vee-validate/dist/rules'],
  },
}

// 追記
// フロントのNuxtからバックエンドのRailsへapi通信を行うとき、URLが違うとブラウザ上でエラーを引き起こします。
// これが、クロスドメイン通信を拒否するCORSエラーです。
// 今回のプロジェクト設計は本番環境は同じURLでapi通信を行うので問題ありませんが、開発環境では
// “http://localhost:4001/” のNuxtから
// “http://localhost:4000/” のGoへ
// api通信を行うためCORSエラーを引き起こします。
// Nuxtでは、プロキシの設定をすることでこのCORSエラーを回避することができます。

// process.env.NODE_ENVには、開発環境の場合’development’、本番環境の場合’production’という文字列が入っています。
// もし、開発環境の場合はプロキシ(代理サーバ)を立ててapi通信を行ってね。という設定になります。
// if (process.env.NODE_ENV === 'development') {
// config.buildModules.push('@nuxtjs/eslint-module')
// @nuxtjs/proxy module settings（開発環境でのプロキシの設定）
// config.proxy = { '/api/v1': 'http://localhost:80' }
// config.proxy = { '/api/': {target: "http://localhost:3000", pathRewrite: {'^/api/v1/': '/'}} }
// '/api/': {target: 'YOUR API URL', pathRewrite: {'^/api/': '/'}}
// }

export default config
