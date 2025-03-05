//推出按钮
@Component
export struct FooterPage {
  build() {
    Column() {
      Button('退出登录')
        .width('90%')
        .height(45)
        .backgroundColor('#e4e8eb')
        .fontColor('#fa2a2d')
        .fontSize(16)
        .fontWeight(900)
        .margin({ top: 80 })
    }
  }
}