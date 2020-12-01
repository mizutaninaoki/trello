<template>
  <v-row justify="center">
    <v-dialog v-model="dialog" persistent max-width="600px" light>
      <template v-slot:activator="{ on }">
        <v-btn color="primary" dark v-on="on">Open Dialog</v-btn>
      </template>
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
          <span class="headline">カードを登録する</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row cols="12"> </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-btn type="submit" class="mx-auto" color="primary">登録</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>
