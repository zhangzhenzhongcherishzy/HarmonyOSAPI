import { common, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
const TAG: string = '[Page_UIAbilityComponentsInteractive]';
const DOMAIN_NUMBER: number = 0xFF00;
@Entry
@Component
struct D0317Demo1 {
  build() {
    Column({space:20}) {
      Button('specified启动模式为指定实例模式 打开文档1')
        .onClick(() => {
          let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
          const RESULT_CODE: number = 1001;
          let want: Want = {
            deviceId: '',
            bundleName: 'com.example.harmonyosarkts',
            abilityName: 'FeatureAAbility',
            moduleName:'AbilityFeatureHAP',
            parameters: {
              // 自定义信息
              info: '来自EntryAbility D0317Demo1页面',
              instanceKey: 'hap1'
            }
          };
          context.startAbility(want).then(() => {
            hilog.info(DOMAIN_NUMBER, TAG, '>>>>startAbility success.');
          }).catch((error: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, TAG, '>>>>startAbility failed.');
          });;
        })
      Button('specified启动模式为指定实例模式 打开文档2')
        .onClick(() => {
          let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
          const RESULT_CODE: number = 1001;
          let want: Want = {
            deviceId: '',
            bundleName: 'com.example.harmonyosarkts',
            abilityName: 'FeatureAAbility',
            moduleName:'AbilityFeatureHAP',
            parameters: {
              // 自定义信息
              info: '来自EntryAbility D0317Demo1页面',
              instanceKey: 'hap2'
            }
          };
          context.startAbility(want).then(() => {
            hilog.info(DOMAIN_NUMBER, TAG, '>>>>startAbility success.');
          }).catch((error: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, TAG, '>>>>startAbility failed.');
          });;
        })
    }
  }
}