import { promptAction } from '@kit.ArkUI';
import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData';

@Entry
@Component
struct D0217Demo2 {
  @State targetImage: string = ''
  @State imageWidth: number = 200
  @State imageHeight: number = 200

  build() {
    //拖拽接收数据案例
    Column() {
      //拖拽测试
      Text('测试拖拽事件发起')
        .width('100%')
        .height(100)
        .textAlign(TextAlign.Center)
        .draggable(true)
        .copyOption(CopyOptions.InApp)
      TextArea({ placeholder: '测试拖拽事件的接收/发送' })
        .width('100%')
        .height(50)
        .draggable(true)
        .copyOption(CopyOptions.InApp)
      //搜索文本框
      Search({ placeholder: '测试拖拽事件的接收' })
        .searchButton('搜索按钮')
        .width('100%')
        .height(80)


      //发送端
      Column() {
        Text('开始拖拽')
          .width('100%')
          .height(40)
          .margin(10)
          .textAlign(TextAlign.Center)
          .backgroundColor('#008888')
        Image($r('app.media.startIcon'))
          .width(100)
          .height(100)
          .draggable(true)
          .margin({ left: 15 })
          .onDragEnd((event) => {
            //onDragEnd里取到的result值在接收方onDrop设置
            if (event.getResult() === DragResult.DRAG_SUCCESSFUL) {
              //触摸事件 event.type === TouchType.Down
              promptAction.showToast({ message: '拖拽成功了' })
            } else if (event.getResult() === DragResult.DRAG_FAILED) {
              promptAction.showToast({ message: '拖拽失败了' })
            }
          })

      }
      .width('100%')

      //接收端
      Column() {
        Image(this.targetImage)
          .width(this.imageWidth)
          .height(this.imageHeight)
          .draggable(true)
          .margin(15)
          .border({
            width: 1
          })//设置该组件上允许落入的数据类型
          .allowDrop([uniformTypeDescriptor.UniformDataType.IMAGE])
          .onDrop((event) => {

            let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords() //提取所有数据记录（数组形式）
            // console.log(`>>>>${records[0].getType()}`)
            // console.log(`>>>>${(records[0] as unifiedDataChannel.Image).imageUri}`)
            //获取拖拽端图片的路径($r则转换为资源文件夹中的编号)
            this.targetImage = (records[0] as unifiedDataChannel.Image).imageUri
            //获取尺寸信息
            let rect: Rectangle = event.getPreviewRect()
            console.log(`>>>>尺寸宽:${rect.width}`)
            console.log(`>>>>尺寸高:${rect.height}`)
            this.imageWidth = Number(rect.width)
            this.imageHeight = Number(rect.height)
            //显示设置result为successful,将该值传递给拖出方的onDragEnd
            event.setResult(DragResult.DRAG_SUCCESSFUL) //向拖拽源反馈操作结果
          })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}