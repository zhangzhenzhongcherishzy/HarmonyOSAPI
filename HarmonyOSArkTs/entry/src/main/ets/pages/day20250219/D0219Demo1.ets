@Entry
@Component
struct D0219Demo1 {
  @State numbers: string[] = []
  @State strings:string[] = []
  @State text: string = 'drag'

  @Builder
  pixelMapBuilder() { //拖拽过程样式
    Column() {
      Text(this.text)
        .fontSize(16)
        .backgroundColor('#75ff4100')
        .width('100%')
        .height(80)
        .textAlign(TextAlign.Center)
    }
  }

  aboutToAppear() {
    for (let i = 1; i <= 15; i++) {
      this.numbers.push(i + '')
    }
  }

  changeIndex(index1: number, index2: number) { //交换数组位置
    let temp: string;
    temp = this.numbers[index1];
    this.numbers[index1] = this.numbers[index2];
    this.numbers[index2] = temp;
  }

  build() {
    Column({ space: 5 }) {
      List({space:10}) {
        ForEach(this.numbers, (day: string) => {
          ListItem() {
            Text(day)
              .fontSize(16)
              .backgroundColor(0xF9CF93)
              .width('100%')
              .height(80)
              .textAlign(TextAlign.Center)
          }
          .width('100%')
        })
      }
      .multiSelectable(true)
      .width('90%')
      .backgroundColor(0xFAEEE0)
      .height('70%')
      .editMode(true) //设置Grid是否进入编辑模式，进入编辑模式可以拖拽Grid组件内部GridItem
      .onItemDragStart((event: ItemDragInfo, itemIndex: number) => { //第一次拖拽此事件绑定的组件时，触发回调。
        this.text = this.numbers[itemIndex]
        return this.pixelMapBuilder() //设置拖拽过程中显示的图片。
      })
      .onItemDrop((event: ItemDragInfo, itemIndex: number, insertIndex: number,
        isSuccess: boolean) => { //绑定此事件的组件可作为拖拽释放目标，当在本组件范围内停止拖拽行为时，触发回调。
        // isSuccess=false时，说明drop的位置在grid外部；insertIndex > length时，说明有新增元素的事件发生
        if (!isSuccess || insertIndex >= this.numbers.length) {
          return
        }
        console.info('beixiang' + itemIndex + '', insertIndex + '') //itemIndex拖拽起始位置，insertIndex拖拽插入位置
        this.changeIndex(itemIndex, insertIndex)
      })
      .onItemMove((from:number,to:number) => {
        console.log(`>>>>移动前索引值${from}:移动后索引值${to}`)
        return true
      })
      .onItemDragEnter((event: ItemDragInfo) => {
        console.log(`>>>>当前拖拽点的x坐标${event.x}:当前拖拽点的y坐标${event.y}`)
      })
      .onItemDragMove((event: ItemDragInfo, itemIndex: number, insertIndex: number) => {
        // console.log(`>>>>触发拖拽移动`)
        // console.log(`>>>>当前拖拽点的x坐标${event.x}:当前拖拽点的y坐标${event.y}:移动得索引是${itemIndex}`)
      })
      .onItemDragLeave((event: ItemDragInfo, itemIndex: number) => {
        console.log(`>>>>当前拖拽点的x坐标${event.x}:当前拖拽点的y坐标${event.y}:移动得索引是${itemIndex}`)
      })
      .onScrollVisibleContentChange((start:VisibleListContentInfo,end:VisibleListContentInfo) => {
        //当前显示界面第一个ListItem或ListItemGroup的详细信息
        console.log(`>>>>第一个listitem得索引${start.index}:第一个listitem得所处的位置${JSON.stringify(start.itemGroupArea)}:第一个listitem得索引${start.itemIndexInGroup}`)
      })
    }.width('100%').margin({ top: 5 })
  }
}