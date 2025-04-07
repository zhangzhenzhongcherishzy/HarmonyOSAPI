import { abilityAccessCtrl, bundleManager, common } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit';
@Entry
@Component
struct D0407Page7 {
  build() {
    Column() {
      Button('检测权限')
        .onClick(() => {
          //程序访问控制管理
          const atManager = abilityAccessCtrl.createAtManager()
          //获取bundle(应用程序包)信息
          const bundleInfo =
            bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
          //动态获取token  应用得唯一标识
          const tokenID = bundleInfo.appInfo.accessTokenId
          //检测权限
          const res = atManager.checkAccessTokenSync(tokenID, 'ohos.permission.READ_CALENDAR')
          AlertDialog.show({
            message: JSON.stringify(res, null, 2)
          })
        })

      //申请授权
      Button('动态向用户申请授权')
        .onClick(async () => {
          //核心api：requestPermissionsFromUser
          //程序访问控制管理
          const atManager = abilityAccessCtrl.createAtManager()

          //动态向用户申请授权
          const result = atManager.requestPermissionsFromUser(getContext(), ['ohos.permission.READ_CALENDAR'])
          AlertDialog.show({
            message: JSON.stringify(result, null, 2)
          })
        })

      //处理授权结果(针对失败，未授权，打开设置页)
      Button('打开设置页，处理失败结果')
        .onClick(() => {
          const context = getContext() as common.UIAbilityContext
          //获取bundle(应用程序包)信息
          const bundleInfo =
            bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
          context.startAbility({
            //打开设置页固定得配置参数
            bundleName: 'com.hauwei.hmos.settings',
            abilityName: 'com.hauwei.hmos.settings.MainAbility',
            uri: 'application_info_entry',
            action: "action.settings.app.info",
            parameters: {
              //按照包名打开对应设置页
              pushParams: bundleInfo.name
            }
          })
        })

      Button('二次授权')
        .onClick(() => {
          let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
          let context: Context = getContext(this) as common.UIAbilityContext;
          atManager.requestPermissionOnSetting(context, ['ohos.permission.READ_CALENDAR'])
            .then((data: Array<abilityAccessCtrl.GrantStatus>) => {
              AlertDialog.show({
                message:JSON.stringify(data)
              })
              console.info('data:' + JSON.stringify(data));
            }).catch((err: BusinessError) => {
            console.error('data:' + JSON.stringify(err));
          });
        })
    }
  }
}