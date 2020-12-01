export default {
  // show.vueページ
  // fetchで初回表示時に全てのlistを取得
  fetchLists({ commit }, payload) {
    commit('setLists', payload)
  },
  // List.vueコンポーネント
  // payload = 削除したいlistのid
  async removeList({ commit }, { listId }) {
    if (confirm('本当にこのリストを削除しますか？')) {
      await this.$axios
        .$delete(`/lists/${listId}`)
        .then((res) => {
          this.$toast.success('削除しました！')
          commit('removeList', listId)
        })
        .catch((error) => {
          // 新規登録の際、エラーがあれば返ってきたエラーメッセージを表示させる
          const messages = error.message
          commit('message/setMessage', messages)
        })
    }
  },
  // ListAddコンポーネント
  // payload = 新しく作成するlistのタイトル
  async addList({ commit }, { title }) {
    const params = new URLSearchParams()
    params.append('title', title)
    await this.$axios
      .$post('/lists', params)
      .then((resList) => {
        // stateに新しいlistを作成
        commit('addList', resList)
      })
      .catch((error) => {
        commit('message/setMessage', error.message)
      })
  },
  // CardAddコンポーネント
  // listId = 追加するlistのid
  // card = コンポーネントから渡された新しく保存するcardの情報
  async addCardToList({ commit }, { listId, card }) {
    // FormDataにアップロードするファイルを設定
    const params = new FormData()
    // 画像を１つ１つ配列に代入していく
    card.images.forEach((image, index) => {
      params.append('card[images][]', image)
    })

    params.append('card[title]', card.title)
    params.append('card[content]', card.content)
    // タグも保存(acts-as-taggable-on使用)
    params.append('card[tag_list]', card.tags)

    await this.$axios
      .$post(`/lists/${listId}/cards`, params, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      })
      .then((resCard) => {
        commit('addCardToList', resCard)
      })
      .catch((errors) => {
        commit('message/setMessage', errors.messages)
      })
  },
  // Cardコンポーネント
  removeCard({ commit }, { card }) {
    // DELETEで何か引数に値を渡したい時は、paramsプロパティを使う
    // 参照： https://qiita.com/yfujii1127/items/991ae9ff29b478a55b1c
    // list_idを引数に入れてrails側で使用する
    this.$axios
      .$delete(`/cards/${card.id}`, { params: { list_id: card.list_id } })
      .then((res) => {
        commit('deleteCard', {
          listId: card.list_id,
          cardId: card.id,
        })
      })
      .catch((error) => {
        this.$store.commit('message/setMessage', error.messages)
      })
  },
  cardUpdate({ commit }, { card }) {
    // FormDataにアップロードするファイルを設定
    const params = new FormData()
    // 画像を１つ１つ配列に代入していく
    card.images.forEach((image) => {
      params.append('card[images][]', image)
    })
    params.append('card[title]', card.title)
    params.append('card[content]', card.content)

    // タグも保存(acts-as-taggable-on使用)
    params.append(
      'card[tag_list]',
      card.tags.map((tag) => tag.name)
    )

    // rails側でparams[:list_id]として使用
    params.append('list_id', card.list_id)
    this.$axios
      .$patch(`/cards/${card.id}`, params, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      })
      .then((resCard) => {
        commit('cardUpdate', resCard)
        this.$toast.success('カードの更新完了しました！')
      })
      .catch((error) => {
        this.$store.commit('message/setMessage', error.messages)
      })
  },
}
