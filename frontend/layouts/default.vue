<template>
  <v-app light>
    <Header />
    <v-main>
      <v-container>
        <ErrorAlert></ErrorAlert>
        <nuxt />
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import ErrorAlert from '~/components/ErrorAlert'
import Header from '~/components/Header'

export default {
  components: {
    ErrorAlert,
    Header,
  },
}
</script>

<style scoped>
#app {
  background-color: #f3f4f5;
}
</style>
