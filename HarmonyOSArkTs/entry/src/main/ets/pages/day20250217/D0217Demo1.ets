/*
* 拖拽事件
*    拖拽框架提供了一种通过鼠标或触屏的方式
*    传递数据，即从一个组件位置拖出数据
*    并拖入到另一个组件上进行响应
*    拖出的一方提供数据，拖入的接收和处理数据。
*    该操作可以让用户方便地移动、复制和删除指定内容
* 拖拽操作：在某个能响应拖出的组件上长按并滑动触发拖拽行为，当用户释放时，拖拽操作结束
* 拖拽背景(背板):用户所拖动数据的形象化展示，
*    开发者可以通过onDragStart的CustomerBuilder
* 拖拽内容:
*    拖动的数据，使用UDMF统一API UnifiedData进行封装
* 拖出对象:
*    触发拖拽操作并提供数据的组件
* 拖出目标:
*    可接收并处理拖动数据的组件
* 拖拽点:
*    鼠标或手指等与屏幕的接触位置，是否进入组件范围的判定是
*    以接触点是否进入范围进行判断
*
* 拖拽流程
*  对于手势长按触发的场景，发出拖拽前框架会对当前组件能否拖拽
*  进行校验。针对默认可拖出组件
*  (Text,TextInput,Search,TextArea,Image)
*  需要判断是否设置了draggable属性为true,其他组件
*  需要额外判断是否设置了onDragStart()回调函数
*  在满足上述条件下，长按500ms可触发拖拽，
*  长按800ms开始做预览图得浮起
*
* onDragStart：第一次拖拽此事件绑定的组件时，长按时间>500ms 手指移动>=10vp 触发该回调
*    event: DragEvent, 拖拽事件的信息
*    extraParams?: string | undefined 拖拽事件的额外信息
*    主要针对拖拽事件写给List相关组件
*     作为发送方
*     selectIndex:当拖拽事件设置ListItem时，表示当前拖拽子元素
*                是父容器的第selectIndex个子元素，从0开始
*                仅在ListItem组件拖拽生效
*     作为接收方
*     insetIndex:当拖拽的元素在List放下时，insetIndex代表被
*                  拖拽元素插入该组件的第insetIndex个位置
*                  仅在List组件拖拽事件生效
* onDrop
*    绑定此事件的组件可以作为拖拽释放目标，当在本组件范围内停止拖拽行为时
*    触发回调。如果没有显示使用event.setResult(),则默认result为
*    DRAG_SUCCESSFUL
*    DragResult
*      DRAG_SUCCESSFUL  拖拽成功,在onDrop中使用
*      DRAG_FAILED      拖拽失败,在onDrop中使用
*      DRAG_CANCELED    拖拽取消,在onDrop中使用
*      DROP_ENABLED     组件允许落下，在onDragMove中使用
*      DROP_DISABLED    组件不允许落下，在onDragMove中使用
*
* onDragEnter
*    拖拽进入组件范围时，触发回调，
*    当监听了onDrop事件,此事件才有效果
*
* onDragMove
*    当拖拽进入组件范围移动，触发回调，
*    当监听了onDrop事件,此事件才有效果
*
* onDragLeave
*    拖拽离开组件范围,触发回调
*    当监听了onDrop事件,此事件才有效果
*
* onDragEnd
*    绑定此事件的组件触发的拖拽结束之后，触发回调
*
* onPreDrag 12+
*    绑定此事件的组件、当触发拖拽发起前不同阶段时，触发回调
*    ACTION_DETECTING_STATUS  0   拖拽手势启动阶段(按下50ms时触发)
*    READY_TO_TRIGGER_DRAG_ACTION 1  拖拽准备完成，可发起拖拽阶段。(按下500ms时触发)
*    PREVIEW_LEFT_STARTED 2 拖拽浮起动效发起阶段 (按下800ms)
*    PREVIEW_LEFT_FINISHED 3 拖拽浮起动效结束阶段 (浮起动效完全结束时触发)
*    PREVIEW_LANDING_STARTED 4 拖拽落回发起阶段(落回动效发起时触发)
*    PREVIEW_LANDING_FINISHED 5 拖拽落回结束阶段(落回动效结束时触发)
*    ACTION_CANCELED_BEFORE_DRAG 6 拖拽浮起落位动效中断
*/
@Entry
@Component
struct D0217Demo1 {
  @State arr: number[] = [1, 2, 3, 4, 5]

  //尽量写在组件内
  @Builder
  myBuilder() {
    Column() {
      Text('这是')
      Text('一段')
      Text('拖拽')
      Text('文本')
    }
  }

  build() {
    Column({ space: 30 }) {
      Text('这是一段待拖拽文本')
        .fontSize(30)
        .draggable(true)//开始拖拽
        .copyOption(CopyOptions.InApp)
        .onDragStart((event) => {
          AlertDialog.show({
            message:'>>>>触发了该回调'
          })
          console.log(`>>>>触发了该回调`)
        })


      Column() {
      }
      .width(100)
      .height(100)
      .border({
        width: 1
      })
      .draggable(true)
      .onDragStart((event) => {
        console.log(`>>>`)
        AlertDialog.show({
          message:'column触发了回调'
        })
      })

      List({ space: 30 }) {
        ForEach(this.arr, (item: number) => {
          ListItem() {
            Text(`这是文本${item}`)
          }
          .width('100%')
          .height(50)
          .onDragStart((event, _index) => {
            AlertDialog.show({
              message:`>>>>此ListItem的下标为:${_index}`
            })
            console.log(`>>>>此ListItem的下标为:${_index}`)
          })
        })
      }
      .width('100%')
      .height(400)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)

    // Column({ space: 50 }) {
    //   Text('这是一段拖拽文本')
    //     .width(200)
    //     .height(200)
    //     .border({
    //       width: 1
    //     })
    //     .fontSize(30)
    //     .draggable(true)//开始拖拽
    //     .onDragStart((event, _Index) => {
    //       console.log(`>>>>拖拽开始`)
    //当前拖拽点相对于屏幕的左上角x轴坐标
    // AlertDialog.show({
    //   message: `当前拖拽点相对于屏幕的左上角x轴坐标${event.getDisplayX()}`
    // })
    //当前拖拽点相对于窗口左上角的x轴坐标
    // AlertDialog.show({
    //   message: `当前拖拽点相对于窗口左上角的x轴坐标${event.getWindowX()}`
    // })
    //向DragEvent中设置拖拽相关数据,拖拽事件注入数据
    // event.setData()
    //从DragEvent中获取相关数据
    //*event.getData()
    //向DragEvent中设置拖拽结果
    //event.setResult()
    //从DragEvent中获取拖拽结果
    //event.getResult()
    //获取拖拽跟手图相对于当前窗口的位置，拖拽发起者的尺寸信息
    //event.getPreviewRect()
    // return this.myBuilder()
    // })
    //拖拽结束
    // .onDragEnd(() => {
    //   AlertDialog.show({
    //     message: `拖拽结束`
    //   })
    // })
    //   Text('这是接收方的文本')
    //     .width(200)
    //     .height(200)
    //     .border({
    //       width: 1
    //     })
    //     .onDragEnter(() => {
    //       console.log(`>>>>拖拽进入了范围`)
    //     })
    //     .onDrop(() => {
    //       console.log(`>>>>Drop拖拽结束`)
    //     })
    //     .onDragMove(() => {
    //       console.log(`>>>>拖拽在目标范围发生了移动`)
    //     })
    //     .onDragLeave(() => {
    //       console.log(`>>>>拖拽对象离开了目标位置`)
    //     })
    // }

  }
}