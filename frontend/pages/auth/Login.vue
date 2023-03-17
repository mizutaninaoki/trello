<template>
  <div class="login">
    <p v-if="user.login" class="text">
      {{ user }}
    </p>
    <form v-else class="form" @submit.prevent>
      <label class="label">
        <span class="label"> email </span>
        <input v-model="email" class="input" type="text" />
      </label>
      <label class="label">
        <span class="label"> password </span>
        <input v-model="password" class="input" type="password" />
      </label>
      <button class="button" type="submit" @click="login">Login</button>
    </form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: '',
      password: '',
    }
  },
  computed: {
    user() {
      return this.$store.getters.user
    },
  },
  methods: {
    login(email, password) {
      this.$store.dispatch('login', {
        email: this.email,
        password: this.password,
      })
    },
  },
}
</script>
