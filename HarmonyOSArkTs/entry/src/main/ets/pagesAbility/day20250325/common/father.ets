import { storage } from './Idata'
import { Son } from './Son'
import { router } from '@kit.ArkUI'

@Entry(storage)
@Component
struct father {
  @LocalStorageLink('bool') fathermessage: boolean|undefined = false

  build() {
    Column() {
      Button("跳转子页面"+ this.fathermessage)
        .onClick(() => {
          router.pushUrl({
            url:"pagesAbility/day20250325/common/Son"
          })
          this.fathermessage = !this.fathermessage
        })
      // Son()
    }
  }
}
