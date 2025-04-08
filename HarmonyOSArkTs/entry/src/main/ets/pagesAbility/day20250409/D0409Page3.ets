import { PreferencesClass } from './common/Preferences'

@Entry
@Component
struct D0408Page4 {
  build() {
    Column({ space: 20 }) {
      Button('退出登录')
        .onClick(() => {
          PreferencesClass.setToken(getContext(),PreferencesClass.defaultStore,'')
        })
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundColor('#f1f2f3')
  }
}