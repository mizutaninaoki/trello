<template>
  <v-alert v-show="alert" type="error" color="red lighten-2" dismissible>
    <p
      v-for="(getMessageText, res, index) in getMessageTexts"
      :key="index"
      class="mb-0"
    >
      {{ getMessageText }}
    </p>
  </v-alert>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  data() {
    return {
      alert: false,
      timeout: 2000,
    }
  },
  computed: {
    isShow() {
      return this.existsMessage()
    },
    getMessageTexts() {
      return this.getMessage()
    },
  },
  watch: {
    isShow() {
      // computedのisShow()を監視している
      this.alert = this.existsMessage()
    },
  },
  methods: {
    ...mapGetters('message', ['getMessage', 'existsMessage']),
  },
}
</script>
