// ページ遷移する時に必ず挟みたい処理
export default async ({ app, store }) => {
  await app.router.afterEach((to, from) => {
    // ページ遷移する時、必ずflashメッセージをクリアする
    store.dispatch('message/clearMessage')
  })
}
