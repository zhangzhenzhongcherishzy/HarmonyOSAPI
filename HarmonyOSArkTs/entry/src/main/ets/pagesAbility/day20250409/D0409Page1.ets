import { PermissionUtil, ToastUtil, WantUtil } from '@pura/harmony-utils';
import { Permissions } from '@kit.AbilityKit';

@Entry
@Component
struct D0409Page1 {
  build() {
    Column({ space: 20 }) {
      Button('校验当前是否已经授权')
        .onClick(() => {
          let p: Permissions = 'ohos.permission.CAMERA'; //相机
          PermissionUtil.checkPermissions(p).then((result) => {
            ToastUtil.showToast(`检测是否授权，结果：${result}`);
          })
        })
      Button('校验是否授权后并申请授权')
        .onClick(() => {
          let p: Permissions = 'ohos.permission.CAMERA'; //相机
          PermissionUtil.checkRequestPermissions(p).then((grant) => {
            ToastUtil.showToast(`检测并申请授权，结果：${grant}`);
            if (!grant) {
              WantUtil.toAppSetting(); //拒绝权限，跳转APP设置页面
            }
          })
        })
      Button('申请授权')
        .onClick(() => {
          let p: Permissions[] = ['ohos.permission.ACTIVITY_MOTION', 'ohos.permission.CAMERA','ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'];
          PermissionUtil.requestPermissions(p).then((grant) => {
            if (grant) {
              ToastUtil.showToast(`申请授权，已通过...`);
            } else { //拒绝权限，二次向用户申请授权
              PermissionUtil.requestPermissionOnSettingEasy(p).then((result) => {
                ToastUtil.showToast(`申请授权，结果：${result}`);
              });
            }
          })
        })
      Button('申请授权，拒绝后并二次向用户申请授权（申请权限，建议使用该方法）')
        .onClick(() => {
          let p: Permissions[] = ['ohos.permission.ACTIVITY_MOTION', 'ohos.permission.CAMERA', 'ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'];
          PermissionUtil.requestPermissionsEasy(p).then((result) => {
            ToastUtil.showToast(`申请授权，结果：${result}`);
          })
        })
      Button('最佳使用案例')
        .onClick(() => {
          let ps: Permissions[] = ['ohos.permission.READ_IMAGEVIDEO', 'ohos.permission.WRITE_IMAGEVIDEO'];
          PermissionUtil.requestPermissions(ps).then((result) => {
            if (result) {
              ToastUtil.showToast(`最佳使用案例授权，已通过...`);
            } else {
              PermissionUtil.requestPermissionOnSetting(ps).then((grant) => {
                ToastUtil.showToast(`最佳使用案例，结果：${grant}`);
              })
            }
          })
        })
      Button("测试")
        .onClick(() => {
          let ps: Permissions[] = ['ohos.permission.CAMERA', 'ohos.permission.READ_IMAGEVIDEO', 'ohos.permission.WRITE_IMAGEVIDEO'];
          PermissionUtil.requestPermissionsEasy(ps).then((grant)=>{
            ToastUtil.showToast(`申请授权，结果：${grant}`);
          })
        })
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundColor('#f1f2f3')
  }
}