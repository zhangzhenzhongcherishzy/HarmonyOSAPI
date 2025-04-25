import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window,display } from '@kit.ArkUI';
import { AppUtil, PreferencesUtil } from '@pura/harmony-utils'
import { efRcp, efRcpConfig } from 'myrcp';

const DOMAIN = 0x0000;

export const storage: LocalStorage = new LocalStorage()

export default class EntryAbility extends UIAbility {
  /*****************************************************************一多开发部分*************************************************************************/
  private windowObj?: window.Window  // 窗口对象
  private curBp?: string // 当前断点标识
  private myWidth?: number // 最小内容宽度
  // ...
  // 根据当前窗口尺寸更新断点
  private updateBreakpoint(windowWidth:number) :void{
    // 将长度的单位由px换算为vp
    let windowWidthVp = windowWidth / (display.getDefaultDisplaySync().densityDPI / 160) // windowWidthVp = px值 / (DPI/160)  // 将物理像素转为虚拟像素(vp)
    let newBp: string = ''
    let newWd: number
    if (windowWidthVp < 320) {
      newBp = 'xs'
      newWd = 360
    } else if (windowWidthVp < 600) {
      newBp = 'sm'
      newWd = 360
    } else if (windowWidthVp < 840) {
      newBp = 'md'
      newWd = 600
    } else {
      newBp = 'lg'
      newWd = 600
    }
    if (this.curBp !== newBp) {
      this.curBp = newBp
      this.myWidth = newWd
      // 使用状态变量记录当前断点值
      AppStorage.setOrCreate('currentBreakpoint', this.curBp)
      // 使用状态变量记录当前minContentWidth值
      AppStorage.setOrCreate('myWidth', this.myWidth)
    }
  }
  /*****************************************************************一多开发部分*************************************************************************/
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    AppUtil.init(this.context)
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    /*****************************************************************一多开发页面断点监听*************************************************************************/
    windowStage.getMainWindow().then((windowObj) => {
      this.windowObj = windowObj
      // 获取应用启动时的窗口尺寸
      this.updateBreakpoint(windowObj.getWindowProperties().windowRect.width)
      // 注册回调函数，监听窗口尺寸变化
      windowObj.on('windowSizeChange', (windowSize)=>{
        this.updateBreakpoint(windowSize.width)
      })
    });
    /*****************************************************************一多开发页面断点监听*************************************************************************/
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    /*****************************************************************rcp三方库初始化部分*************************************************************************/
    //efRcp 初始化
    efRcp
      .enableLogInterceptor()// .addCustomInterceptors([new ResponseCheckTokenInterceptor2(RevalidateTokenRequest.getInstance())])
      .setBaseURL('http://192.168.105.103:8989')// .disableLoading()
      .enableLottie()
        // .disableLoading()
      .create()
    //   .builder()
    // if (!efRcpConfig.token.tokenValue) {
    //   let aToken = PreferencesUtil.getSync("accessToken", "");
    //   efRcpConfig.token.tokenValue = aToken as string
    //   efRcpConfig.token.tokenName = "Authorization";
    // }
    /*****************************************************************rcp三方库初始化部分*************************************************************************/
    windowStage.loadContent("pagesAbility/day20250507/D0507Page1",storage,(err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    /*****************************************************************一多开发取消页面断点监听*************************************************************************/
    if (this.windowObj) {
      this.windowObj.off('windowSizeChange')
    }
    /*****************************************************************一多开发取消页面断点监听*************************************************************************/
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