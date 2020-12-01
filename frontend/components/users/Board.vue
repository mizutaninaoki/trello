<template>
  <div>
    <draggable class="d-inline-block" @end="listDraggableEnd">
      <list v-for="list in lists" :key="list.id" :list="list" />
    </draggable>
    <list-add />
  </div>
</template>

<script>
import Vue from 'vue'
import draggable from 'vuedraggable'
import { mapState } from 'vuex'
import ListAdd from './ListAdd.vue'
import List from './List.vue'

export default Vue.extend({
  components: {
    draggable,
    ListAdd,
    List,
  },
  computed: {
    ...mapState('lists', ['lists']),
  },
  methods: {
    async listDraggableEnd(event) {
      if (event.oldIndex === event.newIndex) {
        return false
      }

      const positionParams = {
        from_position: event.oldIndex,
        to_position: event.newIndex,
      }

      // :idには移動前のlistの並び番号(oldIndex)を入れる
      await this.$axios
        .$patch(`/lists/${event.oldIndex}/list_move`, positionParams)
        .then((resList) => {
          // this.$toast.success('ボードの順番を入れ替えました！')
        })
        .catch((error) => {
          // 新規登録の際、エラーがあれば返ってきたエラーメッセージを表示させる
          const messages = error.response.data.errors
          this.$store.commit('message/setMessage', messages)
          return error
        })
    },
  },
})
</script>
