// xxx.ets
@Entry
@Component
struct D0407Page1 {
  @State message: string = '';

  build() {
    Column() {
      Row({ space: 20 }) {
        Text(this.message).width(200).height(80).backgroundColor(Color.Pink)
          .fontSize(25)
      }.margin(20)
    }
    .width('100%')
    .height(200)
    .borderWidth(2)
    .onDragStart(() => {
      this.message = 'drag'
      console.log("Drag start.")
    })
    .gesture(
      TapGesture()
        .tag("tap1")// 设置点击手势标志
        .onAction(() => {
          this.message = 'tap1'
        })
    )
    .gesture(
      LongPressGesture()
        .tag("longPress1")// 设置长按手势标志
        .onAction(() => {
          this.message = 'longPress'
        })
    )
    .gesture(
      SwipeGesture()
        .tag("swipe1")// 设置滑动手势标志
        .onAction(() => {
          this.message = 'swipe1'
        })
    )
    .gesture(
      PanGesture()
        .tag("pan1")// 设置拖动手势标志
        .onActionStart(() => {
          this.message = 'pan1'
        })
    )
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {//event基础事件信息，可转换为具体手势事件类型
      // 若该手势类型为长按手势，转换为长按手势事件
      if (gestureInfo.type == GestureControl.GestureType.LONG_PRESS_GESTURE) {
        let longPressEvent = event as LongPressGestureEvent;
        console.log("repeat " + longPressEvent.repeat)
      }
      // 若该手势类型为滑动手势，转换为滑动手势事件
      if (gestureInfo.type == GestureControl.GestureType.SWIPE_GESTURE) {
        let swipeEvent = event as SwipeGestureEvent;
        console.log("angle " + swipeEvent.angle)
      }
      // 若该手势类型为拖动手势，转换为拖动手势事件
      if (gestureInfo.type == GestureControl.GestureType.PAN_GESTURE) {
        let panEvent = event as PanGestureEvent;
        console.log("velocity " + panEvent.velocity)
      }
      // 自定义判定标准
      if (gestureInfo.type == GestureControl.GestureType.DRAG) {
        // 返回 REJECT 会使拖动手势失败 拒绝拖动（REJECT）：当手势类型为DRAG时，直接返回REJECT，导致拖动手势（如PanGesture）无法触发。
        return GestureJudgeResult.REJECT;
      } else if (gestureInfo.tag == 'longPress1' && event.fingerList.length > 0 && event.fingerList[0].localY < 100) {
        // 返回 CONTINUE 将保持系统判定。 fingerList: 触摸点列表，包含位置（如localX/Y）等数据。  条件允许长按（CONTINUE）：仅当长按手势标签为longPress1且触摸点在Y坐标<100区域内时，允许系统继续处理长按。
        return GestureJudgeResult.CONTINUE;
      }
      return GestureJudgeResult.CONTINUE;  //其他情况：默认返回CONTINUE，由系统决定是否响应。
    })
  }
}