import { image } from '@kit.ImageKit'
import { componentSnapshot } from '@kit.ArkUI'
import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData'

@Entry
@Component
struct D0217Demo4 {
  //定义状态变量imag.pixelMap用于承接参数
  @State pixmap:image.PixelMap | undefined = undefined
  //Grid容器所有内容的数组
  @State Grid_arr:number[] = []
  //GridItem的是否选中
  @State Grid_select:boolean[] = []
  //每个GridItem的内容
  @State colors: Color[] =
    [
      Color.Red,Color.Blue,Color.Black,
      Color.Brown,Color.Green,Color.Pink,Color.Orange
    ]
  //拖拽预览图内容
  @State previewData: DragItemInfo[] = []
  @State plainText: unifiedDataChannel.PlainText[] = []
  @State plainText1: unifiedDataChannel.PlainText[] = []
  @State arr_select:string[] = []
  @State _text: unifiedDataChannel.PlainText[] = []
  //dragPreview
  //  DragItemInfo
  /*
   *  pixelMap:image.pixelMap,
   *  build 如果第一个参数存在值，那么此参数忽略，
   *  extraInfo:预览图选项 Auto 默认值
   *
   * */
  /*
   * 多选显示效果，右上角的角标数量
   *
   * */
  @State numberBadge: number = 0
  //构建两种样式，分别代表选中和未选中
  @Styles
  normalStyles(){
    .opacity(1)
  }
  @Styles
  SelectStyles(){
    .opacity(0.4)
  }
  //构建宫格容器的数量
  onPageShow(): void {
    for (let i = 0;i<100;i++){
      //为宫格容器添加内容
      this.Grid_arr.push(i)
      //为选择容器添加对应数量的内容
      this.Grid_select.push(false)
      //为预览图添加内容
      this.previewData.push({})
    }
  }
  build() {
    Column({ space: 5 }){
      Grid(){
        ForEach(this.Grid_arr,(item: number) => {
          GridItem(){
            Column()
              .width(50)
              .height(50)
              .opacity(1)
              .backgroundColor(this.colors[item % this.colors.length])
              .id('grid' + item)
          }
          .draggable(true)
          /*
           * 设置组件拖拽时的预览图
           * 将相应下标的预览图数组内容给到对应下标的GridItem
           * */
          .dragPreview(this.previewData[item])
          //当前GridItem是否能够被鼠标框选
          .selectable(true)
          /*
           * 设置当前GridItem的选种状态
           *
           * */
          .selected(this.Grid_select[item])
          /*
           * 多态样式
           *
           * */
          .stateStyles({
            normal:this.normalStyles,
            selected:this.SelectStyles
          })
          .onClick(() => {
            //点击过后将选择状态取反
            this.Grid_select[item] = !this.Grid_select[item]
            //当目标选择状态为true，那么该选项进入拖拽目标
            if(this.Grid_select[item]){
              //将角标自增
              this.numberBadge++
              /*
               * componentSnapshot.get
               *  获取已加载组件的截图，传入组件的组件标识
               *
               *
               * */
              let gridItemId = 'grid' + item
              /*
               * 选中状态下，在拖拽之前调用componentSnapshot.get
               * 方法获取对应组件的image.PixelMap
               *
               * */
              let text:unifiedDataChannel.PlainText = new unifiedDataChannel.PlainText()
              text.textContent = '这是主要内容' + item
              this._text.push(text)

              // console.log(`>>>>增加${this._text.length}`)
              componentSnapshot.get(gridItemId,(error,pixmap:image.PixelMap) => {
                this.pixmap = pixmap
                this.previewData[item] = {
                  pixelMap:this.pixmap,
                }
              })
            }else{
              let text:unifiedDataChannel.PlainText = new unifiedDataChannel.PlainText()
              text.textContent = '这是主要内容' + item
              this._text.splice(this._text.indexOf(text),1)
              // console.log(`>>>>增加${this._text.length}`)
              this.numberBadge--
              // console.log(`>>>>删除${this.arr_select}`)
            }
          })
          //多选拖拽效果，右上角数量角标设置为numberBadge参数
          /*
           * dragPreviewOptions
           *    设置拖拽过程中背景板处理模式以及数量角标的显示
           *
           * */
          .dragPreviewOptions(
            //角标值
            { numberBadge:this.numberBadge },
            //是否开启多选悬浮效果
            {
              isMultiSelectionEnabled:true,
              defaultAnimationBeforeLifting:true
            }
          )
          .onDragStart((event) => {
          })
        },(item:number) => item.toString())
      }
      .width('100%')
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
      .columnsGap(5)
      .rowsGap(10)
      .height(500)
    }
    .width('100%')
    .margin(5)
  }
}