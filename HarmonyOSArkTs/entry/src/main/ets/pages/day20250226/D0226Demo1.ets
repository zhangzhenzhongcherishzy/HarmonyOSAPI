class classA {
  title: string
  text?: string
  image: Resource

  constructor(title: string, images: Resource, text?: string) {
    this.title = title
    this.text = text
    this.image = images
  }
}

@Entry
@Component
struct D0226Demo1 {

  @State data: Array<classA> = [
    new classA('首页', $r('app.media.imgs'), '介绍'),
    new classA('首页', $r('app.media.imgs'), '介绍'),
    new classA('首页', $r('app.media.imgs'), '介绍'),
    new classA('首页', $r('app.media.imgs'), '介绍'),
  ]

  build() {
    Column({space:20}) {
      ForEach(this.data,(item:classA) => {
        Row(){
          Image(item.image).width('50%').height(100)
          Column(){
            Text(item.title)
            Text(item.text)
          }
        }
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: "pages/day20250226/common/default",
            params:{
              title:item.title,
              text:item.text,
              image:item.image
            }
          })
        })
      })
    }
  }
}