import { AVPlayerUtils } from '../utils/AVPlayerUtils';
import { BusinessError, emitter, settings } from '@kit.BasicServicesKit';
import { EmitEventType, PlayStateModel, SongItemType } from '../models/MyMusicModel';
import { songs } from '../constants/MusicConstants';
import { display, window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { PipUtils } from '../utils/PipUtils';

const context: Context = getContext(this);
const TIMEOUT = 0; // Timer ID
const SET_TIME_OUT = 5000; // Interval: 8s

@Entry
@Component
struct PlayingPage {
  //接受全局的播放视频信息
  @State playState: PlayStateModel | null = null
  //是否横屏
  @State isLandscape: boolean = false
  // 视频宽高比（默认竖屏比例 9:16）  默认 9/16 表示竖屏比例（如手机竖屏播放短视频
  @State aspect: number = 9 / 16;
  // 组件宽度（屏幕宽度）
  @State xComponentWidth: number = px2vp(display.getDefaultDisplaySync().width);
  // 组件高度（根据宽高比计算）
  @State xComponentHeight: number = px2vp(display.getDefaultDisplaySync().width * this.aspect);
  //是否锁定横屏
  @State isVideoLock: boolean = false;
  //系统旋转轴锁定状态(1启用 0禁用)
  @State orientationLockState: string = '1'
  //窗口对象
  private windowClass = (context as common.UIAbilityContext).windowStage.getMainWindowSync()
  //画布控制
  private xComponentController: XComponentController = new XComponentController();
  //控制键隐藏与显示定时器
  private timeout: number = 0; // Timer ID
  //控制控件隐藏与显示开关
  @State isClickScreen: boolean = false;

  setTimer(): void {
    let that = this;
    this.timeout = setTimeout(() => {
      that.isClickScreen = false; // Hide the operation panel
    }, SET_TIME_OUT); // Hide in 8 seconds
  }

  clearTimer(): void {
    if (this.timeout !== TIMEOUT) {
      clearTimeout(this.timeout);
      this.timeout = TIMEOUT;
    }
  }

  //格式化毫秒数
  num_time(number: number) {
    //毫秒值 将应该显示的毫秒值拿出来
    const ms: number = number % 1000
    //总秒值
    const second: number = (number - ms) / 1000
    //把秒值转化成分钟
    const min: number = Math.floor(second / 60)
    //将多余的禁止为分钟,直接作为秒数使用
    const s: number = second % 60
    //把分钟和秒值一起返回出去
    return min.toString().padStart(2, "0") + ":" + s.toString().padStart(2, '0')
  }

  aboutToAppear(): void {
    //设置玩视频id进行初始化
    AVPlayerUtils.init()
    //接收当前正在播放歌曲的数据
    emitter.on({ eventId: EmitEventType.UPDATE_STATE }, (data: emitter.EventData) => {
      if (data.data !== undefined) {
        this.playState = new PlayStateModel(JSON.parse(data.data.playState))
      }
    })
    //初始化时获取设备当前的旋转锁定设置
    this.orientationLockState = settings.getValueSync(getContext(this), settings.general.ACCELEROMETER_ROTATION_STATUS,
      settings.domainName.DEVICE_SHARED);
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
          this.windowClass.setSpecificSystemBarEnabled('navigationIndicator', false)
        } else {
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
        this.orientationLockState =
          settings.getValueSync(getContext(this), settings.general.ACCELEROMETER_ROTATION_STATUS,
            settings.domainName.DEVICE_SHARED);
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
      console.info('setWindowOrientation: ' + orientation + ' Succeeded.');
    }).catch((err: BusinessError) => {
      console.info('setWindowOrientation: ' + orientation + ' Failed. Cause: ' + JSON.stringify(err));
    });
  }

  aboutToDisappear(): void {
    AVPlayerUtils.relase()
  }

  build() {
    Column() {
      Stack() {
        //播放画面部分
        Column() {
          XComponent({ id: 'XcomponentID', type: XComponentType.SURFACE, controller: this.xComponentController })
            .width(this.xComponentWidth)
            .height(this.xComponentHeight)
            .onLoad(() => {
              AVPlayerUtils.setSurfaceId(this.xComponentController.getXComponentSurfaceId())
              AVPlayerUtils.callBack((aspect: number) => {
                this.aspect = aspect
                this.xComponentHeight = px2vp(display.getDefaultDisplaySync().width * aspect)
                this.xComponentWidth = px2vp(display.getDefaultDisplaySync().width)
              })
            })
        }

        //播放控件部分
        if (this.isClickScreen) {
          RelativeContainer() {
            //返回按钮
            if (!this.isVideoLock) {
              Image($r('app.media.icon_back'))
                .width(24)
                .height(24)
                .margin({ top: this.isLandscape ? (AppStorage.get<number>('statusBarHeight') || 0) : 12 })
                .onClick(() => {
                  if (this.isExpandedOrHalfFolded()) {
                    this.isLandscape = false
                  } else {
                    this.setOrientation(window.Orientation.USER_ROTATION_PORTRAIT)
                  }
                })
            }
            //是否锁定
            if (this.isLandscape) {
              Image(this.isVideoLock ? $r('app.media.icon_lock') : $r('app.media.icon_lock_open'))
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
                  if (this.isExpandedOrHalfFolded() || this.orientationLockState === '0') {
                    return
                  }
                  if (this.isVideoLock) {
                    this.setOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE);
                  } else {
                    this.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
                  }
                })
            }
            //全屏按钮
            if (!this.isVideoLock) {
              //倍速播放
              Row({ space: 10 }) {
                Text('0.5倍速')
                  .fontColor(Color.White)
                  .onClick(() => {
                    AVPlayerUtils.videoSpeed05()
                  })
                Text('1.0倍速')
                  .fontColor(Color.White)
                  .onClick(() => {
                    AVPlayerUtils.videoSpeed1()
                  })
                Text('1.5倍速')
                  .fontColor(Color.White)
                  .onClick(() => {
                    AVPlayerUtils.videoSpeed15()
                  })
                Text('2.0倍速')
                  .fontColor(Color.White)
                  .onClick(() => {
                    AVPlayerUtils.videoSpeed2()
                  })
              }
              .alignRules({
                top: { anchor: '__container__', align: VerticalAlign.Top },
                right: { anchor: '__container__', align: HorizontalAlign.End }
              })
              .offset({ x: -20, y: 20 })

              Row() {
                Row({ space: 10 }) {
                  //上一曲
                  Image($r('app.media.ic_prev'))
                    .fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      AVPlayerUtils.prev()
                    })
                  //播放按钮
                  Image(this.playState?.isPlay ? $r('app.media.ic_paused') : $r('app.media.ic_play'))
                    .fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      //识别状态,让播放去暂停，让暂停 去播放
                      if (this.playState != undefined) {
                        this.playState.isPlay = !this.playState.isPlay
                        this.playState.isPlay ? AVPlayerUtils.play() : AVPlayerUtils.pause()
                      }
                    })
                  //下一曲
                  Image($r('app.media.ic_next'))
                    .fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      AVPlayerUtils.next()
                    })
                }.margin({ left: 15 })

                //播放进度条
                Row({ space: 4 }) {
                  //视频已经播放的事件
                  Text(this.num_time(Number(this.playState?.time)))
                    .fontSize(12)
                    .fontColor(Color.White)
                  //播放进度
                  Slider({
                    //当前进度
                    value: this.playState?.time,
                    //最小值
                    min: 0,
                    //最大值
                    max: this.playState?.duration,
                    style: SliderStyle.OutSet
                  })
                    .layoutWeight(1)
                    .blockColor(Color.White)//小圆点的颜色
                      //已经划过的颜色
                    .selectedColor(Color.White)//未划过的颜色
                    .trackColor('#ccc5c5c5')//划轨大小'
                    .trackThickness(2)
                    .onChange((time) => {
                      AVPlayerUtils.seek(time)
                    })
                  //视频总时长
                  Text(this.num_time(Number(this.playState?.duration)))
                    .fontSize(12)
                    .fontColor(Color.White)
                }
                .layoutWeight(1)
                .padding({ left: 24, right: 24 })

                //全屏按钮
                Image($r("app.media.icon_zoom_in"))
                  .width(24)
                  .height(24)
                  .onClick(() => {
                    if (this.isExpandedOrHalfFolded()) {
                      this.isLandscape = true
                    } else {
                      this.setOrientation(window.Orientation.USER_ROTATION_LANDSCAPE);
                    }
                  })
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceEvenly)
              .alignRules({
                bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
                right: { anchor: '__container__', align: HorizontalAlign.End }
              })
              .margin({
                left: 16,
                right: 16,
                bottom: 8
              })

            }
          }.width('100%').height('100%')
        }
      }
      .width('100%')
      .backgroundColor(Color.Black)
      .height(this.isLandscape ? '100%' : this.xComponentHeight + (AppStorage.get<number>('statusBarHeight') ?? 0))
      .padding({ top: this.isLandscape ? 0 : (AppStorage.get<number>('statusBarHeight') || 0) })
      .onClick(() => {
        this.isClickScreen = !this.isClickScreen;
        if (this.isClickScreen) {
          this.setTimer();
        } else {
          this.clearTimer();
        }
      })

      //播放列表
      Column() {
        //播放列表 更多文字
        Row() {
          Text('播放列表')
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(500)
          Row() {
            Text($r('app.string.more'))
              .fontSize(14)
              .fontColor($r('sys.color.mask_secondary'))
            Image($r('app.media.chevron_right'))
              .height(24)
              .width(12)
          }
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .height(48)
        .width('100%')
        .padding({
          left: 16,
          right: 16
        })

        //播放列内容
        List({ space: 8 }) {
          ForEach(songs, (item: SongItemType, index: number) => {
            ListItem() {
              Column() {
                Image(item.img)
                  .width('100%')
                  .margin({ bottom: 8 })
                  .objectFit(ImageFit.Cover)
                  .borderRadius(10)
                  .height(100)
                Text(item.name)
                  .fontSize(14)
                  .fontWeight(500)
                  .width('100%')
                  .fontColor(index == this.playState?.playIndex ? '#ED6F21' : '#182431')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .textAlign(TextAlign.Start)
              }
              .width(150)
            }
            .onClick(() => {
              AVPlayerUtils.ChangeplayIndex(item)
              AVPlayerUtils.PlayVideo()
            })
          })
        }
        .listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')
        .height('25%')
        //画中画
        Row() {
          Button('开启画中画')
            .onClick(() => {
              PipUtils.startPip(this.xComponentController)
            })
          Button('关闭画中画')
            .onClick(() => {
              PipUtils.stopPip()
            })
          Button('尺寸画中画')
            .onClick(() => {
              PipUtils.upScreenSize(200,200)
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)
      }
      .width('100%')
      .layoutWeight(1)
    }
  }
}