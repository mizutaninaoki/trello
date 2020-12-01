<template>
  <v-col id="vertical-menu-background" cols="2" class="pa-0">
    <div class="pl-10 pr-2 py-2 white--text font-weight-bold">
      <p class="mb-0">{{ this.$auth.user.nickname }}</p>
    </div>
    <v-divider color="white"></v-divider>
    <nuxt-link to="/MyPage/show">
      <div class="pl-10 pr-2 py-2 white--text font-weight-bold">
        <font-awesome-icon icon="home" style="font-size: 20px" color="white" />
        <span>ホーム</span>
      </div>
    </nuxt-link>
    <div class="pl-10 pr-2 py-2 white--text font-weight-bold">
      <nuxt-link to="/tasks">
        <font-awesome-icon
          icon="clipboard-list"
          style="font-size: 20px"
          color="white"
        />
        <span>タスク一覧</span>
      </nuxt-link>
    </div>
    <div class="pl-10 pr-2 py-2 white--text font-weight-bold">
      <nuxt-link to="/folders">
        <font-awesome-icon
          icon="folder-open"
          style="font-size: 20px"
          color="white"
        />
        <span>フォルダ一覧</span>
      </nuxt-link>
    </div>
    <div class="pl-10 pr-2 py-2 white--text font-weight-bold">
      <nuxt-link to="/schedules/show">
        <font-awesome-icon
          icon="calendar"
          style="font-size: 20px"
          color="white"
        />
        <span>スケジュール</span>
      </nuxt-link>
    </div>
    <div class="pl-10 pr-2 py-2 white--text font-weight-bold">
      <font-awesome-icon icon="cog" style="font-size: 20px" color="white" />
      <span>設定</span>
    </div>
    <v-divider color="white"></v-divider>
    <div class="pl-10 pr-2 py-2 white--text font-weight-bold">
      最近登録したカード
    </div>
  </v-col>
</template>
