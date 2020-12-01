import Vue from 'vue'
import {
  ValidationProvider,
  ValidationObserver,
  localize,
  extend,
} from 'vee-validate'
import ja from 'vee-validate/dist/locale/ja.json' // エラーメッセージを日本語化します
import * as originalRules from 'vee-validate/dist/rules' // 全てのバリデーションルールをimport

// VeeValidateが用意している各ルールを１つ１つ使用するよう場合、以下のように指定
// extend('required', required) // 必須項目のバリデーション
// extend('numeric', numeric)
// extend('email', email)

// 全てのルールをインポート
let rule
for (rule in originalRules) {
  extend(rule, {
    ...originalRules[rule], // eslint-disable-line
  })
}

// カスタムバリデーション
// extend('max', {
//   ...max,
//   message: '10文字以上は入力できません'
// })

// Vue.use(VeeValidate, {
//   locale: "ja",
//   dictionary: {
//     ja: {
//       attributes: {
//         name: "名称！"
//       }
//     }
//   }
// });

// 下記は固定で書く
Vue.component('ValidationProvider', ValidationProvider)
Vue.component('ValidationObserver', ValidationObserver)
localize('ja', ja)
