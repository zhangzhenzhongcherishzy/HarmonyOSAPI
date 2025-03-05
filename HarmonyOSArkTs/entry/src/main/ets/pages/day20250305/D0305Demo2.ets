import { HeaderPage } from './common/HeaderPage'
import { FooterPage } from './common/FooterPage'
import { MainPage } from './common/MainPage'

@Entry
@Component
struct D0305Demo2 {
  build() {
    Column({ space: 12 }) {
      //头部
      HeaderPage()
      //列表区
      MainPage()
      //退出按钮
      FooterPage()
    }
    .width('100%')
    .height('100%')
    .padding({ left: 12, right: 12 })
    .backgroundColor('#f1f2f3')
  }
}







