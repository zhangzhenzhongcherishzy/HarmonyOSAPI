import { promptAction } from '@kit.ArkUI';
import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData';

@Entry
@Component
struct D0217Demo3 {
  @State message: string = 'Hello World';
  @State targetImage:string = ''
  @State imageWidth:number = 200
  @State imageHeight:number = 200
  @State targetText: string | undefined = ''
  build() {
    Column(){
      //发送端
      Column(){
        Text('开始拖拽')
          .width('100%')
          .height(40)
          .margin(10)
          .textAlign(TextAlign.Center)
          .backgroundColor('#008888')
        Image('https://ww1.sinaimg.cn/mw690/0065KVCFgy1hrawj709mzj31d82yoe81.jpg')
          .width(100)
          .height(100)
        Column(){
          Text('更换图片')
        }
        .width(100)
        .height(100)
        .draggable(true)
        //制作图片数据
        .onDragStart((event) => {
          let _Image: unifiedDataChannel.Image = new unifiedDataChannel.Image()
          //只能使用本地图片,取用resources文件夹里面的图片方式为 resources/base/media/startIcon.png
          _Image.imageUri = 'resources/base/media/startIcon.png'
          let data: unifiedDataChannel.UnifiedData = new unifiedDataChannel.UnifiedData(_Image)
          event.setData(data)
        })

        Column(){
          Text('这是文本内容制作器')
            .fontSize(30)
        }
        .width('100%')
        .height(100)
        .draggable(true)
        .onDragStart((event) => {
          //PlainText 明文
          let _text: unifiedDataChannel.PlainText = new unifiedDataChannel.PlainText()
          _text.abstract = '这是摘要内容'
          _text.textContent = '这是主要内容'
          let data: unifiedDataChannel.UnifiedData = new unifiedDataChannel.UnifiedData(_text)
          event.setData(data)
        })
      }
      .width('100%')
      //接收端
      Column(){
        Image(this.targetImage)
          .width(this.imageWidth)
          .height(this.imageHeight)
          .draggable(true)
          .margin(15)
          .border({
            width:1
          })
            //设置该组件上允许落入的数据类型
          .allowDrop([uniformTypeDescriptor.UniformDataType.IMAGE])
          .onDrop((event) => {
            // console.log(`>>>>${JSON.stringify(event.getData())}`)
            let records:Array<unifiedDataChannel.UnifiedRecord> =
              event.getData().getRecords()
            // console.log(`>>>>${records[0].getType()}`)
            console.log(`>>>>${(records[0] as unifiedDataChannel.Image).imageUri}`)
            //获取拖拽端图片的路径($r则转换为资源文件夹中的编号)
            this.targetImage = (records[0] as unifiedDataChannel.Image).imageUri
            //获取尺寸信息
            let rect: Rectangle = event.getPreviewRect()
            console.log(`>>>>尺寸宽:${rect.width}`)
            console.log(`>>>>尺寸高:${rect.height}`)
            this.imageWidth = Number(rect.width)
            this.imageHeight = Number(rect.height)
            //显示设置result为successful,将该值传递给拖出方的onDragEnd
            event.setResult(DragResult.DRAG_SUCCESSFUL)
          })
        Column(){
          Text(this.targetText)
            .fontSize(20)
        }
        .width(100)
        .height(100)
        .border({
          width:1
        })
        .allowDrop([uniformTypeDescriptor.UniformDataType.PLAIN_TEXT])
        .onDrop((event) => {
          //定义特殊类型数组承接拖拽过来的所有数据
          let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords()
          //取数据中的第一个定义为明文类型
          let plainText: unifiedDataChannel.PlainText = records[0] as unifiedDataChannel.PlainText
          //取明文数据中的摘要部分，因为摘要的类型为 string | undefined ，需要对数据进行类型操作
          this.targetText = plainText.textContent
        })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}