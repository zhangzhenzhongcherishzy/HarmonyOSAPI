import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct D0411Page2 {
  private context = getContext(this) as common.UIAbilityContext;
  @State message4: string = 'Hello World';

  build() {
    Column({ space: 20 }) {
      Text(this.message4 + '我是另一个页面')
        .onClick(()=>{
          this.message4 = '你好，世界'
          let meeage5 = '你好，美女'
          this.context.eventHub.emit('seconds', this.message4, meeage5)
        })
      Button('跳转至第一个页面')
        .onClick(() => {
          router.back()
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f2f3')
  }
}