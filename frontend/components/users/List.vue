<template>
  <v-card class="list rounded-top mx-3 d-inline-block" width="270">
    <div class="text-center background-main-pink list-header">
      <span class="list-title px-3 pb-3 font-weight-bold white--text">{{
        list.title
      }}</span>
      <div
        class="text-right deletelist pointer pr-2 d-inline-block white--text font-weight-bold"
        @click="removeList"
      >
        ×
      </div>
    </div>
    <!-- group属性を使うことで他のコンポーネントへドラッグ&ドロップさせる、または他のコンポーネントからのドラッグ&ドロップを受け付けることができます。
      互いのコンポーネントを同じnameにすることで実装できます。-->
    <draggable
      :options="{ group: 'cardGroup', animation: 150 }"
      :data-list-id="list.id"
      class="pa-4"
      @end="draggableEnd"
    >
      <card
        v-for="card in list.cards"
        :key="card.id"
        :card-title="card.title"
        :list-id="list.id"
        :card-id="card.id"
        :list-title="list.title"
        :card="card"
      />
    </draggable>
    <card-add :list-id="list.id" />
  </v-card>
</template>

<script>
import draggable from 'vuedraggable'
import CardAdd from '~/components/users/CardAdd'
import Card from '~/components/users/Card'

export default {
  components: {
    CardAdd,
    Card,
    draggable,
  },
  props: {
    list: {
      type: Object,
      required: false,
    },
  },
  methods: {
    removeList() {
      this.$store.dispatch('lists/removeList', { listId: this.list.id })
    },
    async draggableEnd(event) {
      // もし移動前と移動後のindexとlistIdが一緒であれば、データがおかしいためfalseを返す
      if (
        event.oldIndex === event.newIndex &&
        event.from.dataset.listId === event.to.dataset.listId
      ) {
        return false
      }

      // listのポジションを代入しておく
      const positionParams = {
        from: event.oldIndex,
        to: event.newIndex,
        from_list_id: event.from.dataset.listId,
        to_list_id: event.to.dataset.listId,
      }

      // :idには移動後(to)のlist_id(list_id)を入れる
      await this.$axios
        .$patch(`/lists/${event.to.dataset.listId}/move`, positionParams)
        .then((resList) => {})
        .catch((error) => {
          this.$store.commit('message/setMessage', error.message)
        })
    },
  },
}
</script>

<style lang="scss" scoled>
.list {
  vertical-align: top;
}

.list-background {
  background-color: #fff;
}

.rounded-top {
  border-top-left-radius: 12px !important;
  border-top-right-radius: 12px !important;
}

.list-header {
  position: relative;
}

.deletelist {
  position: absolute;
  top: 2px;
  right: 4px;
  &:hover {
    cursor: pointer;
  }
}
</style>
