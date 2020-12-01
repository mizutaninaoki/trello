<template>
  <v-row id="board" ma-0>
    <vertical-menu />
    <v-col cols="10">
      <v-row>
        <v-col>
          <div class="font-weight-bold">フォルダ一覧</div>
        </v-col>
      </v-row>
      <v-row>
        <v-col>
          <p>フォルダ一覧ページです！</p>
        </v-col>
      </v-row>
    </v-col>
  </v-row>
</template>

<script>
import VerticalMenu from '~/components/VerticalMenu.vue'

export default {
  components: {
    VerticalMenu,
  },
}
</script>

<style lang="scss" scoped>
// trelloのように画面をはみ出して横スクロールできるようにするには以下のcssを加える必要あり！
#board {
  -webkit-user-select: none;
  user-select: none;
  white-space: nowrap;
  margin: 0;
  overflow-x: auto;
  overflow-y: hidden;
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
}

#vertical-menu-background {
  background-color: #667572;
}
</style>
