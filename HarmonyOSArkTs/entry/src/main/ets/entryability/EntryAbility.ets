import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { AppUtil, PreferencesUtil } from '@pura/harmony-utils'
import { efRcp, efRcpConfig } from 'myrcp';

const DOMAIN = 0x0000;

export const storage: LocalStorage = new LocalStorage()

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    AppUtil.init(this.context)
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    //efRcp 初始化
    efRcp
      .enableLogInterceptor()// .addCustomInterceptors([new ResponseCheckTokenInterceptor2(RevalidateTokenRequest.getInstance())])
      .setBaseURL('http://192.168.105.144:8989')// .disableLoading()
      .enableLottie()
      // .disableLoading()
      .create()
    //   .builder()
    // if (!efRcpConfig.token.tokenValue) {
    //   let aToken = PreferencesUtil.getSync("accessToken", "");
    //   efRcpConfig.token.tokenValue = aToken as string
    //   efRcpConfig.token.tokenName = "Authorization";
    // }
    windowStage.loadContent("pagesAbility/day20250422/D0422Page1",storage,(err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }



      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}