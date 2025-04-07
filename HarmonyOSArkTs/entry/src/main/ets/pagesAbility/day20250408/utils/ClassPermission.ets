import { abilityAccessCtrl, bundleManager, common, Permissions, Want } from "@kit.AbilityKit";
import { BusinessError } from "@kit.BasicServicesKit";

class ClassPermission {
  /**
   * 检查是否授权
   */
  checkPermission(permissions: Permissions[]) {
    //程序访问控制管理
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    //获取bundle(应用程序包)信息
    let bundleInfo: bundleManager.BundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    //动态获取token  应用得唯一标识
    const tokenID = bundleInfo.appInfo.accessTokenId
    //检测权限（兼容权限组）  利用map映射，使checkAccessTokenSync可以检测多个权限，并返回
    const res = permissions.map(item => atManager.checkAccessTokenSync(tokenID, item))
    //检测授权状态
    const isTrue = res.every(item => item === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    //判断是否授权
    if (isTrue) {
      //已授权
      AlertDialog.show({
        message: '已有授权'
      })
    } else {
      //未授权
      AlertDialog.show({
        message: '未授权'
      })
    }
  }

  /**
   * 动态申请授权
   */
  async resquestPermission(permissions: Permissions[]) {
    //程序访问控制管理
    const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    //动态向用户申请授权
    const result = await atManager.requestPermissionsFromUser(getContext(), permissions)
    //检测授权状态
    const isTrue = result.authResults.every(item => item === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    //判断是否授权
    if (isTrue) {
      //已授权
      AlertDialog.show({
        message: '授权完成，可以继续操作'
      })
    } else {
      //未授权
      AlertDialog.show({
        message: '未授权，请完成授权'
      })
    }
  }

  /**
   * 处理授权结果(打开设置页)
   */
  openPermissionSettingsPage() {
    //获取上下文信息
    const context = getContext() as common.UIAbilityContext
    //获取bundle信息
    const bundleInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    //通过上下文startAbility方法打开设置页
    context.startAbility({
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      uri: "application_info_entry",
      parameters: {
        pushParams: bundleInfo.name
      }
    }).then(() => {
      console.log('打开成功')
    }).catch((err: BusinessError) => {
      console.log('打开失败' + err)
    })
  }

  /**
   * 二次授权
   */
  againPermission(permissions: Permissions[]) {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let context: Context = getContext(this) as common.UIAbilityContext;
    atManager.requestPermissionOnSetting(context, permissions)
      .then((data: Array<abilityAccessCtrl.GrantStatus>) => {
        AlertDialog.show({
          message: '触发二次获取成功:' + JSON.stringify(data)
        });
      })
      .catch((err: BusinessError) => {
        AlertDialog.show({
          message: '触发二次获取失败:' + JSON.stringify(err)
        })
      });
  }
}

//导出
export const permissionsManager = new ClassPermission()