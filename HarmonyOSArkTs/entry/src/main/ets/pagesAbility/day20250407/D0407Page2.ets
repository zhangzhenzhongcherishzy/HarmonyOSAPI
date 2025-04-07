// xxx.ets
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct D0407Page2 {
  scroller: Scroller = new Scroller()

  build() {
    Scroll(this.scroller) {
      Column({ space: 8 }) {
        Text("Drag 上下两层 上层绑定长按，下层绑定拖拽。先长按后平移上半区红色区域只会响应长按，先长按后平移下半区蓝色区域只会响应拖拽")
          .width('100%')
          .fontSize(20)
          .fontColor('0xffdd00')
          .backgroundColor(0xeeddaa00)
        Stack({ alignContent: Alignment.Center }) {
          Column() {
            // 模拟上半区和下半区
            Stack().width('200vp').height('100vp').backgroundColor(Color.Red)
            Stack().width('200vp').height('100vp').backgroundColor(Color.Blue)
          }
          .width('200vp')
          .height('200vp')

          /*事件传递流程：
              用户触摸蓝色区域（Y ≥ 100）时：
                  上层 Stack 的长按手势判定返回 REJECT
                  事件传递至下层 Image，触发拖动手势
              用户触摸红色区域（Y < 100）时：
                  上层 Stack 的长按手势判定返回 CONTINUE
                  触发长按手势，显示提示信息
           */
          // Stack的下半区是绑定了拖动手势的图像区域。
          Image($r('sys.media.ohos_app_icon'))
            .draggable(true)
            .onDragStart(() => {
              promptAction.showToast({ message: "Drag 下半区蓝色区域，Image响应" })
            })
            .width('100vp')
            .height('100vp')
          // Stack的上半区是绑定了长按手势的浮动区域。
          Stack() {
          }
          .width('200vp')
          .height('200vp')
          .hitTestBehavior(HitTestMode.Transparent) //.hitTestBehavior(HitTestMode.Transparent) 设置触摸穿透，使下层 Image 可以接收事
          .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
            // 确定tag标志是否有值
            if (gestureInfo.tag) {
              console.log("gestureInfo tag" + gestureInfo.tag.toString())
            }
            console.log("gestureInfo Type " + gestureInfo.type.toString() + " isSystemGesture " +
            gestureInfo.isSystemGesture);
            console.log("pressure " + event.pressure + " fingerList.length " + event.fingerList.length
              + " timeStamp " + event.timestamp + " sourceType " + event.source.toString() + " titleX " + event.tiltX +
              " titleY " + event.tiltY + " sourcePool " + event.sourceTool.toString());
            // 如果是长按类型手势，判断点击的位置是否在上半区
            if (gestureInfo.type == GestureControl.GestureType.LONG_PRESS_GESTURE) {
              //event.fingerList[0].localY < 100： fingerList：触摸点列表（支持多点触控） localY：触摸点相对于组件左上角的Y坐标
              if (event.fingerList.length > 0 && event.fingerList[0].localY < 100) {
                return GestureJudgeResult.CONTINUE
              } else {
                return GestureJudgeResult.REJECT //GestureJudgeResult.REJECT： 阻止长按手势触发，释放事件给下层组件（蓝色区域的拖动手势）
              }
            }
            return GestureJudgeResult.CONTINUE
          })
          .gesture(GestureGroup(GestureMode.Parallel,
            LongPressGesture()
              .onAction((event: GestureEvent) => {
                promptAction.showToast({ message: "LongPressGesture 长按上半区 红色区域，红色区域响应" })
              })
              .tag("tap111")
          ))

        }.width('100%')
      }.width('100%')
    }
  }
}