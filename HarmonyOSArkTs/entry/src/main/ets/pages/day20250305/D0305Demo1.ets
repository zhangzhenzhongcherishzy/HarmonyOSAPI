class DataObj {
  image: Resource
  text: string
  other?: string

  constructor(image: Resource, text: string, other?: string) {
    this.image = image
    this.text = text
    this.other = other
  }
}

@Entry
@Component
struct D0305Demo1 {
  @State minelist: Array<DataObj> = [
    new DataObj($r('app.media.news'), '推送通知', '厦门站我们不见不散'),
    new DataObj($r('app.media.data'), '数据管理'),
    new DataObj($r('app.media.menu'), '菜单设置'),
    new DataObj($r('app.media.about'), '关于'),
    new DataObj($r('app.media.storage'), '清除缓存'),
    new DataObj($r('app.media.privacy'), '隐私协议')
  ]

  @Builder
  IfApplyColoursToADrawing(items: DataObj) {
    Row() {
      Row({ space: 12 }) {
        Image(items.image).width(22).height(22)
        Text(items.text)
      }

      if (items.other === undefined) {
        Image($r('app.media.right_grey')).width(12).height(12)
      } else {
        Toggle({ type: ToggleType.Switch, isOn: false })
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding({ left: 12, right: 22 })
  }

  build() {
    Column({ space: 12 }) {
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

      //列表区
      List() {
        ForEach(this.minelist, (item: DataObj) => {
          ListItem() {
            this.IfApplyColoursToADrawing(item)
          }
          .height(48)
        })
      }
      .backgroundColor('#fff')
      .borderRadius(16)
      .padding({ top: 4, bottom: 4 })
      .divider({
        //分割线
        strokeWidth: 0.2,
        color: Color.Gray,
        startMargin: 42,
        endMargin: 30
      })

      //退出按钮
      Button('退出登录')
        .width('90%')
        .height(45)
        .backgroundColor('#e4e8eb')
        .fontColor('#fa2a2d')
        .fontSize(16)
        .fontWeight(900)
        .margin({ top: 80 })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 12, right: 12 })
    .backgroundColor('#f1f2f3')
  }
}