export default {
  lists: (state) => state.lists,
  // state内にて、引数に渡されたlistIdと同じidのlistを返す
  list: (state) => (listId) => {
    return state.lists.find((list) => list.id === listId)
  },
  cards: (state) => (listId) => {
    return state.lists.find((list) => list.id === listId).cards
  },
  card: (state) => (listId, cardId) => {
    const list = state.lists.find((list) => list.id === listId)
    return list.cards.find((card) => card.id === cardId)
  },
}
