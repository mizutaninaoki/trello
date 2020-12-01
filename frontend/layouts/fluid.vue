<template>
  <v-app light>
    <Header />
    <v-main>
      <v-container column justify-center align-center fluid pa-0>
        <ErrorAlert></ErrorAlert>
        <nuxt />
      </v-container>
    </v-main>
    <Footer />
  </v-app>
</template>

<script>
import ErrorAlert from '~/components/ErrorAlert'
import Header from '~/components/Header'
import Footer from '~/components/Footer'

export default {
  components: {
    ErrorAlert,
    Header,
    Footer,
  },
}
</script>

<style scoped>
#app {
  background-color: #f3f4f5;
}
</style>
