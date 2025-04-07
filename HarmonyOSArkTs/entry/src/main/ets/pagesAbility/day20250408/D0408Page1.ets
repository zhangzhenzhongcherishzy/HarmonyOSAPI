import { permissionsManager } from './utils/utils'
@Entry
@Component
struct D0408Page1 {
  build() {
    Column({ space: 20 }) {
      Button('检查授权状态')
        .onClick(() => {
          permissionsManager.checkPermission(['ohos.permission.READ_CONTACTS','ohos.permission.WRITE_CONTACTS'])
        })
      Button('动态得向用户申请授权')
        .onClick(() => {
          permissionsManager.resquestPermission(['ohos.permission.READ_CONTACTS','ohos.permission.WRITE_CONTACTS'])
        })
      Button('处理授权结果')
        .onClick(() => {
          permissionsManager.openPermissionSettingsPage()
        })
      Button('二次授权')
        .onClick(() => {
          permissionsManager.againPermission(['ohos.permission.READ_CONTACTS','ohos.permission.WRITE_CONTACTS'])
        })
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundColor('#f1f2f3')
  }
}