@Entry
@Component
struct ScrollExample {
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      List() {
        ForEach(this.arr, (item: number) => {
          ListItem() {
            Text(item.toString())
              .width('100%')
              .height(150)
              .backgroundColor(0xFFFFFF)
              .borderRadius(15)
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .margin({ top: 10 })
          }
        }, (item: string) => item)
      }
      .scrollBar(BarState.On) // 滚动条常驻显示
      .scrollBarColor(Color.Gray) // 滚动条颜色
      .scrollBarWidth(10) // 滚动条宽度
      .friction(0.6)
      .edgeEffect(EdgeEffect.None)
      .onReachStart(() => {
        AlertDialog.show({
          message: '111'
        })
      })
      .onReachEnd(() => {
        AlertDialog.show({
          message: '222'
        })
      })
    }.width('100%').height('100%').backgroundColor(0xDCDCDC)
  }
}