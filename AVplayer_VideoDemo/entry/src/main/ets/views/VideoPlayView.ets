import { display, window } from '@kit.ArkUI';
import { BusinessError, settings } from '@kit.BasicServicesKit';
import { AVPlayerUtil } from '../utils/AVPlayerUtil';
import Logger from '../utils/Logger';
import { common } from '@kit.AbilityKit';

const context: Context = getContext(this);

@Component
export struct VideoPlayView {
  //是否横屏
  @State isLandscape: boolean = false
  // 视频宽高比（默认竖屏比例 9:16）  默认 9/16 表示竖屏比例（如手机竖屏播放短视频
  @State aspect: number = 9 / 16;
  // 组件宽度（屏幕宽度）
  @State xComponentWidth: number = px2vp(display.getDefaultDisplaySync().width);
  // 组件高度（根据宽高比计算）
  @State xComponentHeight: number = px2vp(display.getDefaultDisplaySync().width * this.aspect);
  //画布控制
  private xComponentController: XComponentController = new XComponentController();
  //控制播放器工具类
  private player?: AVPlayerUtil
  //是否锁定横屏
  @State isVideoLock: boolean = false;
  //系统旋转轴锁定状态(1启用 0禁用)
  @State orientationLockState: string = '1'
  //窗口对象
  private windowClass = (context as common.UIAbilityContext).windowStage.getMainWindowSync()

  //生命周期
  aboutToAppear() {
    /**
     * 初始化时获取设备当前的旋转锁定设置
     * getContext(this)：获取当前组件的上下文。
     * settings.general.ACCELEROMETER_ROTATION_STATUS：系统设置的键名，代表“自动旋转开关”
     * settings.domainName.DEVICE_SHARED：设置所属的域，表示设备共享设置
     * 结果：orientationLockState 会被赋值为 '1'（启用自动旋转）或 '0'（禁用自动旋转）
     */
    this.orientationLockState = settings.getValueSync(getContext(this), settings.general.ACCELEROMETER_ROTATION_STATUS, settings.domainName.DEVICE_SHARED);
    // 监听窗口大小变化
    this.windowClass.on('windowSizeChange', (size) => {
      let viewWidth = px2vp(size.width);
      let viewHeight = px2vp(size.height);
      if (this.isExpandedOrHalfFolded()) {
        //保持竖屏布局
        this.xComponentWidth = viewWidth;
        this.xComponentHeight = viewWidth * this.aspect;
      } else {
        if (viewWidth > viewHeight) {
          // 横屏：高度为屏幕高度，宽度按比例计算
          this.xComponentHeight = viewHeight
          this.xComponentWidth = viewHeight / this.aspect
          this.isLandscape = true
          this.windowClass.setSpecificSystemBarEnabled('navigationIndicator',false)
        }else {
          // 竖屏：宽度为屏幕宽度，高度按比例计算
          this.xComponentHeight = viewWidth * this.aspect;
          this.xComponentWidth = viewWidth;
          this.windowClass.setSpecificSystemBarEnabled('navigationIndicator', true);
          this.isLandscape = false;
        }
      }
    })
    // 监听系统旋转锁定设置变化
    settings.registerKeyObserver(context, settings.general.ACCELEROMETER_ROTATION_STATUS,
      settings.domainName.DEVICE_SHARED, () => {
        this.orientationLockState = settings.getValueSync(getContext(this), settings.general.ACCELEROMETER_ROTATION_STATUS, settings.domainName.DEVICE_SHARED);
      });
  }

  //检测是否处于折叠状态
  isExpandedOrHalfFolded(): boolean {
    return display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED ||
      display.getFoldStatus() == display.FoldStatus.FOLD_STATUS_HALF_FOLDED
  }
  // 当用户通过系统设置切换旋转锁定时，更新 orientationLockState，用于后续判断是否允许自动旋转
  setOrientation(orientation: number) {
    this.windowClass.setPreferredOrientation(orientation).then(() => {
      Logger.info('setWindowOrientation: ' + orientation + ' Succeeded.');
    }).catch((err: BusinessError) => {
      Logger.info('setWindowOrientation: ' + orientation + ' Failed. Cause: ' + JSON.stringify(err));
    });
  }
  aboutToDisappear(): void {
    settings.unregisterKeyObserver(context, settings.general.ACCELEROMETER_ROTATION_STATUS,
      settings.domainName.DEVICE_SHARED);

    this.windowClass.off('windowSizeChange');
  }
  build() {
    Stack() {
      //视频播放控件
      Column() {
        XComponent({ type: XComponentType.SURFACE, controller: this.xComponentController })
          .width(this.xComponentWidth)
          .height(this.xComponentHeight)
          .onLoad(() => {
            //实例化
            this.player = new AVPlayerUtil()
            //把XComponent SurfaceId绑定给 工具类中的 this.surfaceId
            this.player.setSurfaceId(this.xComponentController.getXComponentSurfaceId())
            //初始化工具类
            this.player.initPlayer('videoTest.mp4', (aspect: number) => {
              this.aspect = aspect
              this.xComponentHeight = px2vp(display.getDefaultDisplaySync().width * aspect)
              this.xComponentWidth = px2vp(display.getDefaultDisplaySync().width)
            })
          })
      }

      //控制按钮
      RelativeContainer() {
        //返回按钮
        if(!this.isVideoLock){
          Image($r('app.media.icon_back'))
            .width(24)
            .height(24)
            .margin({top: this.isLandscape ? (AppStorage.get<number>('statusBarHeight') || 0) : 12})
            .onClick(() => {
              if(this.isExpandedOrHalfFolded()){
                this.isLandscape =  false
              }else {
                this.setOrientation(window.Orientation.USER_ROTATION_PORTRAIT)
              }
            })
        }
        //是否锁定
        if(this.isLandscape){
          Image(this.isVideoLock  ? $r('app.media.icon_lock') : $r('app.media.icon_lock_open'))
            .height(24)
            .width(24)
            .fillColor(Color.White)
            .alignRules({
              top: { anchor: '__container__', align: VerticalAlign.Center },
              left: { anchor: '__container__', align: HorizontalAlign.Start }
            })
            .margin({ left: (AppStorage.get<number>('statusBarHeight') || 0) })
            .offset({ y: -12 })
            .onClick(() => {
              //通过点击是否锁定，控制返回按钮是否显示
              this.isVideoLock = !this.isVideoLock
              if(this.isExpandedOrHalfFolded() || this.orientationLockState === '0'){
                return
              }
              if(this.isVideoLock){
                this.setOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE);
              } else {
                this.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
              }
            })
        }
        //全屏按钮
        if(!this.isLandscape){
          Image($r("app.media.icon_zoom_in"))
            .width(24)
            .height(24)
            .alignRules({
              bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
              right: { anchor: '__container__', align: HorizontalAlign.End }
            })
            .margin({
              right: 16,
              bottom: 8
            })
            .onClick(() => {
              if(this.isExpandedOrHalfFolded()){
                this.isLandscape = true
              }else {
                this.setOrientation(window.Orientation.USER_ROTATION_LANDSCAPE);
              }
            })
        }
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .backgroundColor(Color.Black)
    /**
     * 为什么竖屏需要加状态栏高度？
     * 在竖屏时，视频播放区域可能需要避开状态栏（如顶部显示标题/控制栏），通过增加状态栏高度，确保视频下方内容不会被遮挡
     */
    .height(this.isLandscape ? '100%' : this.xComponentHeight + (AppStorage.get<number>('statusBarHeight') ?? 0))
    /**
     * 为什么要设置顶部内边距？
     * 在沉浸式全屏布局中，内容可能延伸到状态栏下方（参考之前代码的 setWindowLayoutFullScreen(true)）。通过设置 padding-top，为状态栏留出空间，避免视频内容被状态栏覆盖。
     */
    .padding({ top: this.isLandscape ? 0 : (AppStorage.get<number>('statusBarHeight') || 0) })
  }
}