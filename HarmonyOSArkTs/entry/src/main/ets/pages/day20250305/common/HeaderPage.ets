//头部
@Component
export struct HeaderPage {
  build() {
    Column() {
      //标题
      Text('我的')
        .width('100%')
        .padding({ top: 12, left: 12 })
        .fontWeight(900)
        .fontSize(24)
      //头像
      Row() {
        Image($r('app.media.account'))
          .width(46).height(46)
        Column() {
          Text('Mr.ZhangZhenZhong').fontSize(20)
          Text('763557238@qq.com').fontSize(12)
        }
        .margin({ left: 21 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .height(100)
      .margin({ top: 12 })
      .padding({ left: 24 })
      .backgroundColor('#fff')
      .borderRadius(16)
    }
  }
}