import { router } from '@kit.ArkUI'

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
struct Default {

  @State data: Array<classA> = [
    (router.getParams() as classA)
  ]

  build() {
    Column(){
      Button('传递的参数')
        .onClick(() => {
          AlertDialog.show({
            message:`获取的参数为${JSON.stringify(this.data)}`
          })
        })
      ForEach(this.data,(item:classA) => {
        Row(){
          Image(item.image).width('50%').height(100)
          Column(){
            Text(item.title)
            Text(item.text)
          }
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f2f3')
  }
}