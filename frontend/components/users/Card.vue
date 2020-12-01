<template>
  <v-row justify="center">
    <v-dialog v-model="dialog" max-width="600px" light>
      <template v-slot:activator="{ on }">
        <div class="card" v-on="on">
          <v-card class="px-3 pb-3 pt-1 mb-3" width="240">
            <div class="text-right">
              <div
                class="deletelist pointer px-1 d-inline-block"
                @click.prevent.stop="removeCard"
              >
                ×
              </div>
            </div>
            <div class="text-left caption">
              {{ $moment(card.created_at).format('YYYY/MM/DD') }}
            </div>
            <div class="text-left font-weight-bold">
              {{ card.title }}
            </div>
            <div
              class="text-left caption"
              style="white-space: pre-wrap"
              v-text="$options.filters.TruncateText(card.content)"
            ></div>
          </v-card>
        </div>
      </template>
      <template v-if="edit">
        <card-edit :card="card" @updated="closeModal" @reset="editable" />
      </template>
      <template v-else>
        <v-card>
          <div class="text-right pa-2">
            <font-awesome-icon
              icon="times-circle"
              style="font-size: 20px"
              class="close-icon"
              color="gray"
              @click="dialog = false"
            />
          </div>
          <v-card-title>
            <h3 class="headline">{{ listTitle }}</h3>
            <span>{{ card.created_at | DateNormal }}</span>
            <v-btn
              type="submit"
              class="text-right"
              color="secondary"
              @click="editable"
              >編集する</v-btn
            >
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row cols="12">
                <font-awesome-icon icon="clipboard" style="font-size: 20px" />
                <h3>{{ card.title }}</h3>
              </v-row>
              <p class="mb-2">画像</p>
              <v-row>
                <v-col v-for="image in card.images" :key="image.id" cols="4">
                  <a ref="noopener" :href="image.image_url" target="_blank">
                    <v-img :src="image.image_url" aspect-ratio="1"></v-img>
                  </a>
                  <p>{{ image.filename }}</p>
                </v-col>
              </v-row>
              <v-row>
                <v-chip v-for="tag in card.tags" :key="tag.id">{{
                  tag.name
                }}</v-chip>
              </v-row>
            </v-container>
          </v-card-text>
        </v-card>
      </template>
    </v-dialog>
  </v-row>
</template>

<script>
import CardEdit from '~/components/users/CardEdit'

export default {
  components: {
    CardEdit,
  },
  props: {
    listTitle: {
      type: String,
      required: true,
    },
    card: {
      type: Object,
    },
  },
  data() {
    return {
      dialog: false,
      edit: false,
    }
  },
  methods: {
    editable() {
      this.edit = !this.edit
    },
    closeModal() {
      this.dialog = !this.dialog
    },
    removeCard() {
      this.$store.dispatch('lists/removeCard', { card: this.card })
    },
  },
}
</script>

<style lang="scss" scoped>
.card {
  &:hover {
    cursor: pointer;
  }
}
</style>
