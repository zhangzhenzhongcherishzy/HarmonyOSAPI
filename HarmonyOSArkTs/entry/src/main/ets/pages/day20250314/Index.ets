@Entry
@Component
struct Index{
  @State num:number = 0
  build() {
    Scroll(){
      Column(){
        Text('Hello World' + Math.floor(this.num))
        Text('Hello World' + Math.floor(this.num))
        Text('Hello World' + Math.floor(this.num))
      }
      .backgroundColor(Color.Red)
      .width('100%')
      .height(3000)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height(500)
    .onWillScroll((xOffset: number, yOffset: number, scrollState: ScrollState) => {
      this.num = this.num + yOffset
      if(this.num < 0){
        this.num = 0
      }
      console.log(`yOffset${yOffset}`)
    })
  }
}