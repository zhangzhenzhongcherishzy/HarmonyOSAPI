// xxx.ets
@Entry
@Component
struct D0407Page3 {
  @State text: string = ""

  build() {
    Column({ space: 20 }) {
      Text("{x:0,y:0,width:'50%',height:'100%'}")
      // 热区宽度为按钮的一半，点击右侧无响应
      Button("button1")
        .responseRegion({ x: 0, y: 0, width: '50%', height: '100%' })
        .onClick(() => {
          this.text = 'button1 clicked'
        })

      // 为一个组件添加多个热区
      Text("[{x:'100%',y:0,width:'50%',height:'100%'}," + "\n{ x: 0, y: 0, width: '50%', height: '100%' }]")
      Button("button2")
        .responseRegion([
          { x: '100%', y: 0, width: '50%', height: '100%' }, // 第一个热区宽度为按钮的一半，点击按钮右侧宽度一半区域，点击事件生效
          { x: 0, y: 0, width: '50%', height: '100%' } // 第二个热区宽度为按钮的一半，点击button2左半边，点击事件生效
        ])
        .onClick(() => {
          this.text = 'button2 clicked'
        })
      // 热区大小为整个按钮，且下移一个按钮高度，点击button3下方按钮大小区域，点击事件生效
      Text("{x:0,y:'100%',width:'100%',height:'100%'}")
      Button("button3")
        .responseRegion({ x: 0, y: '100%', width: '100%', height: '100%' })
        .onClick(() => {
          this.text = 'button3 clicked'
        })

      Text(this.text).margin({ top: 50 })
    }.width('100%').margin({ top: 10 })
  }
}