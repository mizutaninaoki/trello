export default {
  // ページロード時セットする
  // payload = DBから取得したユーザーが持つ全てのlist
  setLists(state, payload) {
    state.lists = payload
  },
  // listを削除する
  removeList(state, listId) {
    // idが一致しないlistだけ残すことによって、idが一致するlistだけ削除される
    state.lists = state.lists.filter((list) => {
      return list.id !== listId
    })
  },
  // 新しくlistを作成時、pushする
  addList(state, resList) {
    state.lists.push(resList)
  },
  /// /////Card/////////////////////
  // 新しくcardを作成時、pushする
  // 第二引数はlistインスタンス
  // @param payload == listインスタンス
  addCardToList(state, resCard) {
    const list = state.lists.find((list) => list.id === resCard.list_id)
    // resCard.dataの中に@cardのデータが入っている
    // active_model_serializersで返した場合、dataの中にインスタンスが入っている
    list.cards.push(resCard)
  },
  // cardを削除する
  deleteCard(state, { listId, cardId }) {
    const list = state.lists.find((list) => list.id === listId)
    list.cards = list.cards.filter((card) => {
      // 削除したいcardインスタンス以外を返す
      return card.id !== cardId
    })
  },
  titleUpdate(state, payload) {
    const list = state.lists.find((list) => list.id === payload.card.list_id)
    const card = list.cards.find((card) => card.id === payload.card.id)
    card.title = payload.title
  },
  contentUpdate(state, payload) {
    const list = state.lists.find((list) => list.id === payload.card.list_id)
    const card = list.cards.find((card) => card.id === payload.card.id)
    card.content = payload.content
  },
  onFileChange(state, payload) {
    const list = state.lists.find((list) => list.id === payload.card.list_id)
    const card = list.cards.find((card) => card.id === payload.card.id)
    // payload.addImages.forEach((addImage) => card.images.push(addImage))
    card.images.push(payload.selectedFile)
  },
  tagsUpdate(state, payload) {
    const list = state.lists.find((list) => list.id === payload.card.list_id)
    const card = list.cards.find((card) => card.id === payload.card.id)
    card.tags = payload.tags.map((tag) => ({ name: tag }))
  },
  // 編集画面で画像を削除する
  deletePreviewImage(state, payload) {
    const list = state.lists.find((list) => list.id === payload.card.list_id)
    const card = list.cards.find((card) => card.id === payload.card.id)
    card.images.splice(payload.index, 1)
  },
  // 編集後、stateの値をDBに保存した値に合わせて変更する
  // payload = DBに保存したcardオブジェクト
  cardUpdate(state, resCard) {
    const list = state.lists.find((list) => list.id === resCard.list_id)
    const card = list.cards.find((card) => card.id === resCard.id)
    card.title = resCard.title
    card.content = resCard.content
    card.images = resCard.images
    card.tags = resCard.tags
  },
}
