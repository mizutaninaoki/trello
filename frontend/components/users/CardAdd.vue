<template>
  <v-row justify="center">
    <v-dialog v-model="dialog" max-width="600" light>
      <template v-slot:activator="{ on }">
        <v-btn
          color="#f38181"
          class="white--text font-weight-bold mb-5"
          v-on="on"
        >
          <font-awesome-icon
            icon="plus"
            style="font-size: 16px"
            class="close-icon"
            color="#ffffff"
          />
          &nbsp;&nbsp;新しいカードを登録する</v-btn
        >
      </template>
      <v-card>
        <validation-observer ref="observer" v-slot="{}">
          <v-form @submit.prevent="addCardToList()">
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
              <span class="headline">カードを登録する</span>
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
                <v-row cols="12">
                  <v-col
                    v-for="(image, index) in card.images"
                    :key="image.name"
                    md="4"
                  >
                    <div class="image-preview-box">
                      <v-img
                        :ref="'image'"
                        class="image-preview"
                        max-width="150"
                        aspect-ratio="1"
                      />
                      {{ image.name }}
                      <div class="image-close-icon pa-2">
                        <font-awesome-icon
                          icon="times-circle"
                          style="font-size: 20px"
                          class="close-icon"
                          color="gray"
                          @click="deleteSelectedImage(index)"
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
                        v-model="card.title"
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
                      v-model="card.content"
                      color="cyan"
                      label="Label"
                      dense
                      outlined
                    ></v-textarea>
                  </v-col>
                  <v-col cols="12">
                    <v-combobox
                      v-model="card.tags"
                      :tags="card.tags"
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
              <v-btn type="submit" class="mx-auto" color="primary">登録</v-btn>
            </v-card-actions>
          </v-form>
        </validation-observer>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
import { ValidationObserver, ValidationProvider } from 'vee-validate'

export default {
  components: {
    ValidationObserver,
    ValidationProvider,
  },
  props: {
    listId: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      dialog: false,
      card: {
        images: [], // 画像アップロード
        title: '',
        content: '',
        tags: [],
      },
    }
  },
  methods: {
    // asyncだからVeeValidationのhandleSubmitやpassesがあっても、送信されてしまう
    async addCardToList() {
      const isValid = await this.$refs.observer.validate()
      if (!isValid) {
        return false
      }

      this.$store.dispatch('lists/addCardToList', {
        listId: this.listId,
        card: this.card,
      })

      // コンポーネントのdataを初期化
      this.card = {
        images: [],
        title: '',
        content: '',
        tags: [],
      }
      this.dialog = false // ダイアログを閉じる
      this.$toast.success('カードの登録完了しました！')

      // バリデーションが通っている状態で送信ボタンがクリックされた場合の処理(二重クリックされた時のため)
      // フォーム送信などの処理完了後、以下のリセットを呼び出す。
      // ここではダイアログですぐ閉じるため、下記処理は必要ないかもしれない
      requestAnimationFrame(() => {
        this.$refs.observer.reset()
      })
    },
    onFileChange(selectedFiles) {
      // 選択された画像を１枚ずつthis.card.imagesにpushする
      selectedFiles.forEach((selectedFile) => {
        this.card.images.push(selectedFile)
      })

      // 選択された画像をプレビューとして表示させるために、画像のsrcを代入して、readAsDataURLで画像を表示させる
      this.card.images.forEach((image, index) => {
        const reader = new FileReader()
        // onloadは、FileReaderのイベントです。データの読み込みが正常に完了した時にloadイベントが発生し、ここに設定したコールバック関数が呼び出されます。
        reader.onload = (e) => {
          this.$refs.image[index].src = reader.result
        }
        reader.readAsDataURL(image)
      })
    },
    // プレビュー画像を削除
    deleteSelectedImage(index) {
      this.card.images.splice(index, 1)
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
