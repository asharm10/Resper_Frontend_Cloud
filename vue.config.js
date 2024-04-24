const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: [
    'vuetify'
  ]
})

module.exports = {
  css: {
    loaderOptions: {
      scss: {
        prependData: `
        @import "@src/scss/variables.scss";
        `

      }
    }
  }
}