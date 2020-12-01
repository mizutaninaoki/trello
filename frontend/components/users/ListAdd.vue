<template>
  <v-card class="pa-2 mx-3 d-inline-block">
    <form @submit.prevent="addList()">
      <input
        v-model="title"
        type="text"
        class="white"
        placeholder="新しいリストを追加"
        @blur="addList()"
      />
      <v-btn color="#f38181" class="white--text font-weight-bold" type="submit">
        追加
      </v-btn>
    </form>
  </v-card>
</template>

<script>
export default {
  data() {
    return {
      title: '',
    }
  },
  methods: {
    addList() {
      if (this.title === '') return
      this.$store.dispatch('lists/addList', { title: this.title })
      this.title = ''
    },
  },
}
</script>
