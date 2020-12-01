<template>
  <v-card>
    <validation-observer ref="observer" v-slot="{}">
      <v-form @submit.prevent="cardUpdate">
        <div class="text-right pa-2">
          <font-awesome-icon
            icon="times-circle"
            style="font-size: 20px"
            class="close-icon"
            color="gray"
            @click="$emit('updated')"
          />
        </div>
        <v-btn @click="$emit('reset')"> 編集キャンセル </v-btn>
        <v-card-title>
          <span class="headline">カードを編集する</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row cols="12">
              <div class="mb-3">
                <v-file-input
                  type="file"
                  multiple
                  show-size
                  label="画像ファイルをアップロードしてください"
                  prepend-icon="mdi-image"
                  accept="image/*"
                  @change="onFileChange"
                />
              </div>
            </v-row>
            <v-row id="image-area" cols="12">
              <v-col
                v-for="(image, index) in $store.getters['lists/card'](
                  card.list_id,
                  card.id
                ).images"
                :key="image.id"
                md="4"
              >
                <div class="image-preview-box">
                  <v-img
                    :ref="'image'"
                    :src="image.image_url"
                    class="image-preview"
                    max-width="150"
                    aspect-ratio="1"
                  />
                  {{ image.filename }}
                  <div class="image-close-icon pa-2">
                    <font-awesome-icon
                      icon="times-circle"
                      style="font-size: 20px"
                      class="close-icon"
                      color="gray"
                      @click="deletePreviewImage(index, $event)"
                    />
                  </div>
                </div>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12">
                <validation-provider
                  v-slot="{ errors }"
                  rules="required"
                  name="タイトル"
                >
                  <v-text-field
                    v-model="title"
                    :error-messages="errors"
                    label="タイトル"
                    outlined
                    dense
                    required
                  ></v-text-field>
                </validation-provider>
              </v-col>
              <v-col>
                <v-textarea
                  v-model="content"
                  color="cyan"
                  label="Label"
                  dense
                  outlined
                ></v-textarea>
              </v-col>
              <v-col cols="12">
                <v-combobox
                  ref="tags"
                  v-model="tags"
                  label="タグ"
                  outlined
                  multiple
                  chips
                  deletable-chips
                  append-icon=""
                ></v-combobox>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-btn type="submit" class="mx-auto" color="primary">更新</v-btn>
        </v-card-actions>
      </v-form>
    </validation-observer>
  </v-card>
</template>

<script>
import { ValidationObserver, ValidationProvider } from 'vee-validate'

export default {
  components: {
    ValidationObserver,
    ValidationProvider,
  },
  props: {
    card: {
      type: Object,
    },
  },
  data() {
    return {
      dialog: false,
    }
  },
  computed: {
    title: {
      get() {
        return this.$store.getters['lists/card'](
          this.card.list_id,
          this.card.id
        ).title
      },
      set(value) {
        this.$store.commit('lists/titleUpdate', {
          title: value,
          card: this.card,
        })
      },
    },
    content: {
      get() {
        return this.$store.getters['lists/card'](
          this.card.list_id,
          this.card.id
        ).content
      },
      set(value) {
        this.$store.commit('lists/contentUpdate', {
          content: value,
          card: this.card,
        })
      },
    },
    tags: {
      get() {
        return this.$store.getters['lists/card'](
          this.card.list_id,
          this.card.id
        ).tags.map((tag) => tag.name)
      },
      set(value) {
        // valueには今までと新しく追加したタグ全てが配列で格納されている
        this.$store.commit('lists/tagsUpdate', {
          tags: value,
          card: this.card,
        })
      },
    },
  },
  methods: {
    cardUpdate() {
      this.$store.dispatch('lists/cardUpdate', {
        card: this.$store.getters['lists/card'](
          this.card.list_id,
          this.card.id
        ),
      })

      // ダイアログを閉じる
      this.$emit('updated')

      // バリデーションが通っている状態で送信ボタンがクリックされた場合の処理(二重クリックされた時のため)
      // フォーム送信などの処理完了後、以下のリセットを呼び出す。
      // ここではダイアログですぐ閉じるため、下記処理は必要ないかもしれない
      requestAnimationFrame(() => {
        this.$refs.observer.reset()
      })
    },
    // selectedFilesは新たにアップロードされた画像
    onFileChange(selectedFiles) {
      const vm = this
      // 選択された画像を１枚ずつthis.card.imagesにpushする
      selectedFiles.forEach((selectedFile) => {
        this.$store.commit('lists/onFileChange', {
          selectedFile,
          card: this.card,
        })
      })

      // 選択された画像をプレビューとして表示させるために、画像のsrcを代入して、readAsDataURLで画像を表示させる
      this.$store.getters['lists/card'](
        this.card.list_id,
        this.card.id
      ).images.forEach((image, index) => {
        const reader = new FileReader()
        // onloadは、FileReaderのイベントです。データの読み込みが正常に完了した時にloadイベントが発生し、ここに設定したコールバック関数が呼び出されます。
        reader.onload = (e) => {
          vm.$refs.image[index].src = reader.result
        }
        reader.readAsDataURL(image)
      })
    },
    // プレビュー画像を削除
    deletePreviewImage(index, event) {
      this.$store.commit('lists/deletePreviewImage', {
        index,
        card: this.card,
        event,
      })
    },
  },
}
</script>

<style lang="scss" scoped>
.tag-input span.chip {
  background-color: #1976d2;
  color: #fff;
  font-size: 1em;
}

.tag-input span.v-chip {
  background-color: #1976d2;
  color: #fff;
  font-size: 1em;
  padding-left: 7px;
}

.tag-input span.v-chip::before {
  content: 'label';
  font-family: 'Material Icons';
  font-weight: normal;
  font-style: normal;
  font-size: 20px;
  line-height: 1;
  letter-spacing: normal;
  text-transform: none;
  display: inline-block;
  white-space: nowrap;
  word-wrap: normal;
  direction: ltr;
  -webkit-font-feature-settings: 'liga';
  -webkit-font-smoothing: antialiased;
}

.close-icon {
  &:hover {
    cursor: pointer;
  }
}

//プレビュー画像
.image-preview {
  border-radius: 8px;
}

.image-preview-box {
  position: relative;
}

.image-close-icon {
  position: absolute;
  top: 0;
  right: 10px;
}
</style>
