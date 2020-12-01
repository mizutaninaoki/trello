import Vue from 'vue'

Vue.directive('auto-focus', {
  // el ディレクティブがひも付く要素。DOM を直接操作するために使用できます。
  // binding https://jp.vuejs.org/v2/guide/custom-directive.htmlを確認
  // vnode Vue のコンパイラによって生成される仮想ノード。
  inserted(el, binding, vnode) {
    // insertedではなく、発火をbindにした時は、このカスタムディレクティブは要素がレンダリングされたときに、対象の要素にフォーカスします。
    // bindした瞬間はまだ要素はレンダリングされていないので、Vue.nextTick()で待っています。
    // Vue.nextTick(function () {
    el.focus()
    // })
  },
})
