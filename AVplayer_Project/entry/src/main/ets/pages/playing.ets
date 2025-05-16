import { defaultState, EmitEventType, PlayStateModel, SongItemType } from '../models/Index'
import { emitter } from '@kit.BasicServicesKit'
import { AVPlayerUtils } from '../utils/AVPlayerUtils'
import { LyricController, LyricParser, LyricView2 } from '@seagazer/cclyric'
import { MockData } from '../common/MockData'
import { MusicData } from '../common/MusicData'
import { common } from '@kit.AbilityKit'

@Entry
@Component
struct playing {
  //透明效果
  @State opacityNum: number = 1
  @State @Watch('anniMethod') playState: PlayStateModel = defaultState

  //字体、唱片随着播放蹦迪
  anniMethod() {
    //当歌曲播放状态发生了变化 字体随着有幻彩颜色
    if (this.playState.isPlay) {
      this.randomNum = Math.random() * 50
      this.randomShakenX = 2 - Math.random() * 4
      this.randomShakenY = 2 - Math.random() * 4
      this.randomColor =
        `rgb(${Math.floor(Math.random() * 255)},${Math.floor(Math.random() * 255)},${Math.floor(Math.random() * 255)})`
    }
    //通过监听事件来实时更新歌词信息
    this.lyricController.updatePosition(AVPlayerUtils.time)
  }

  //唱片的变色效果
  @State randomNum: number = 0
  @State randomColor: string = 'rgb(0,0,0)'
  //用于文字的晃动效果
  @State randomShakenX: number = 0
  @State randomShakenY: number = 0
  //唱片的旋转角度
  @State angle: number = 0

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

  //控制播放列表的高度
  @State panelHeight: string = '0%'
  //歌词控制器
  private lyricController: LyricController = new LyricController()
  //歌词解析器
  private parser = new LyricParser()

  //组件生周期，实现订阅接受歌曲信息
  aboutToAppear() {
    //接收当前正在播放歌曲的数据
    emitter.on({ eventId: EmitEventType.UPDATE_STATE }, (data: emitter.EventData) => {
      if (data.data !== undefined) {
        this.playState = new PlayStateModel(JSON.parse(data.data.playState))
      }
    })
    setTimeout(() => {
      //测试歌曲名字是否传递
      // console.log(">>>>name:" + this.playState.name)
      //解析歌词
      // let lyric = this.parser.parse(MockData.src1)
      // let lyric = this.parser.parse(MusicData('给我一个理由忘记.lrc'))
      let lyric = this.parser.parse(MusicData(this.playState.name + '.lrc'))
      //设置歌词
      this.lyricController.setLyric(lyric)
      // 自定义歌词样式属性
      this.lyricController
        .setTextSize(14)//设置歌词绘制的缓存量，在屏幕外面绘制一定数量的歌词，提升上下滑动的性能
        .setCacheSize(4)//歌词文本普通颜色
        .setTextColor('#fff')//设置文本聚焦颜色，当前播放的歌词属于聚焦状态
        .setHighlightColor('#fff')//设置歌词行间距 默认16vp
        .setLineSpace(16)//设置无歌词时的提示语 默认为--
        .setEmptyHint('当前没有歌词')//设置歌词的显示模式
        .setAlignMode('center')
    }, 100)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      //播放控件
      Stack() {
        //变色背景
        Image(this.playState.img)
          .width('100%')
          .height('100%')
          .blur(1000)
        Swiper() {
          //内容
          Column() {
            Column() {
              //唱片图片
              Stack({ alignContent: Alignment.Top }) {
                Row() {
                  Row() {
                    Image(this.playState.img)
                      .width('70%')
                      .borderRadius(400)
                  }
                  .width('100%')
                  .height('100%')
                  .backgroundImage($r('app.media.ic_cd'))
                  .backgroundImageSize(ImageSize.Cover)
                  .justifyContent(FlexAlign.Center)
                  .borderRadius('50%')
                  .clip(true)
                  .aspectRatio(1)
                  .shadow({
                    radius: this.randomNum,
                    color: this.randomColor
                  })
                  .rotate({ angle: this.angle })
                  .animation({
                    duration: 100,
                    tempo: this.playState.isPlay ? 10 : 0,
                    curve: Curve.Linear,
                    onFinish: () => {
                      if (this.playState.isPlay) { //待修改
                        this.angle += 0.5
                      }
                    }
                  })
                }
                .margin({ top: 50 })
                .width('90%')
                .aspectRatio(1)
                .justifyContent(FlexAlign.Center)
                .padding(24)

                //唱针
                Image($r('app.media.ic_stylus'))
                  .width(200)
                  .aspectRatio(1)
                  .rotate({
                    //根据播放状态决定唱针的角度
                    angle: this.playState.isPlay ? -45 : -60,
                    centerX: 100,
                    centerY: 30
                  })
                  .animation({ duration: 500 })
              }

              //歌曲信息
              Stack() {
                Column() {
                  //歌曲名称
                  Text(this.playState.name)
                    .fontSize(28)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.primary_dark'))
                  //歌曲作者
                  Text(this.playState.author)
                    .fontSize(18)
                    .fontColor($r('app.color.primary_dark'))
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
                .zIndex(1)
                .translate({
                  x: this.randomShakenX,
                  y: this.randomShakenY
                })

                Column({ space: 8 }) {
                  //歌曲名称
                  Text(this.playState.name)
                    .fontSize(28)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.primary_light'))
                  //歌曲作者
                  Text(this.playState.author)
                    .fontSize(18)
                    .fontColor($r('app.color.primary_light'))
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
                .zIndex(2)
                .translate({
                  x: this.randomShakenX,
                  y: this.randomShakenY
                })

                Column({ space: 8 }) {
                  //歌曲名称
                  Text(this.playState.name)
                    .fontSize(28)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color.White)
                  //歌曲作者
                  Text(this.playState.author)
                    .fontSize(18)
                    .fontColor(Color.White)
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
                .zIndex(3)
              }
              .layoutWeight(1)
              .width('100%')

              //歌词
              Column() {
                LyricView2({
                  controller: this.lyricController,
                  enableSeek: true, // 开启滑动歌词seek能力
                  seekUIColor: '#ffefe5e5', //滑动定位的按钮和文本颜色
                  seekLineColor: '#80ffffff', //滑动定位线的颜色
                  seekUIStyle: "listItem", // 滑动定位样式（seekLine传统样式，listItem类似抖音汽水音乐样式）
                  onSeekAction: (position) => { // 滑动歌词触发seek定位回调
                    AVPlayerUtils.avPlayer?.seek(position)
                    return true
                  }
                })
              }
              .height('15%')
              .margin({ top: 5, bottom: 10 })

              //收藏、点赞、转发
              Row() {
                Badge({
                  value: '99+',
                  style: { badgeSize: 12, badgeColor: '#45cccccc', borderColor: Color.Transparent }
                }) {
                  Image($r('app.media.ic_like')).fillColor(Color.White).width(24)
                }

                Badge({
                  value: '10w+',
                  style: { badgeSize: 12, badgeColor: '#45cccccc', borderColor: Color.Transparent }
                }) {
                  Image($r('app.media.ic_comment_o')).fillColor(Color.White).width(24)
                }

                Badge({
                  value: 'hot',
                  style: { badgeSize: 12, badgeColor: '#45cccccc', borderColor: Color.Transparent }
                }) {
                  Image($r('app.media.ic_bells_o')).fillColor(Color.White).width(24)
                }

                Badge({
                  value: 'vip',
                  style: { badgeSize: 12, badgeColor: '#45cccccc', borderColor: Color.Transparent }
                }) {
                  Image($r('app.media.ic_download_o')).fillColor(Color.White).width(24)
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceAround)

              //播放
              Column() {
                //进度条
                Row({ space: 4 }) {
                  //歌曲已经播放的事件
                  Text(this.num_time(this.playState.time))
                    .fontSize(12)
                    .fontColor(Color.White)
                  //播放进度
                  Slider({
                    //当前进度
                    value: this.playState.time,
                    //最小值
                    min: 0,
                    //最大值
                    max: this.playState.duration,
                    style: SliderStyle.OutSet
                  })
                    .layoutWeight(1)
                    .blockColor(Color.White)//小圆点的颜色
                      //已经划过的颜色
                    .selectedColor(Color.White)//未划过的颜色
                    .trackColor('#ccc5c5c5')//划轨大小'
                    .trackThickness(2)
                    .onChange((time) => {
                      AVPlayerUtils.avPlayer?.seek(time)
                    })
                  //歌曲总时长
                  Text(this.num_time(this.playState.duration))
                    .fontSize(12)
                    .fontColor(Color.White)
                }
                .width('100%')
                .padding(24)

                //控件按钮
                Row() {
                  if (this.playState.isPlay) {
                    //切换按钮模式
                    if (this.playState.playMode === 'auto') {
                      Image($r('app.media.ic_auto'))
                        .fillColor(Color.White)
                        .width(30)
                        .onClick(() => {
                          AVPlayerUtils.changeMode('random')
                        })
                    } else if (this.playState.playMode === 'repeat') {
                      Image($r('app.media.ic_repeat'))
                        .fillColor(Color.White)
                        .width(30)
                        .onClick(() => {
                          AVPlayerUtils.changeMode('auto')
                        })
                    } else if (this.playState.playMode === 'random') {
                      Image($r('app.media.ic_random'))
                        .fillColor(Color.White)
                        .width(30)
                        .onClick(() => {
                          AVPlayerUtils.changeMode('repeat')
                        })
                    }
                  } else {
                    Image($r('app.media.ic_auto'))
                      .fillColor(Color.White)
                      .width(30)
                      .onClick(() => {
                        AlertDialog.show({
                          message: '播放列表为空'
                        })
                      })
                  }
                  //上一首
                  Image($r('app.media.ic_prev'))
                    .fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      AVPlayerUtils.prev()
                    })
                  //播放按钮
                  Image(this.playState.isPlay ? $r('app.media.ic_paused') : $r('app.media.ic_play'))
                    .fillColor(Color.White)
                    .width(50)
                    .onClick(() => {
                      //识别状态,让播放去暂停，让暂停 去播放
                      if (this.playState.playList.length > 0) {
                        this.playState.isPlay = !this.playState.isPlay
                        this.playState.isPlay ? AVPlayerUtils.play() : AVPlayerUtils.pause()
                      } else {
                        AlertDialog.show({
                          message: '暂无播放歌曲'
                        })
                      }
                    })
                  //下一首
                  Image($r('app.media.ic_next'))
                    .fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      AVPlayerUtils.next()
                    })
                  //播放列表
                  Image($r('app.media.ic_song_list'))
                    .fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      //展开播放列表
                      this.panelHeight = '100%'
                    })
                }
                .width('100%')
                .padding({ bottom: 24 })
                .justifyContent(FlexAlign.SpaceAround)
              }
              .width('100%')
            }
            .layoutWeight(1)
            .width('100%')
          }
        }
        //修改圆点的样式，是否显示导航器圆点
        .indicator(false)
      }
      .backgroundColor('#cc000000')

      //播放列表
      Column() {
        //控制将列表收起
        Column() {
        }
        .width('100%')
        .layoutWeight(1)
        .onClick(() => {
          this.panelHeight = '0%'
        })

        //播放列表
        Column() {
          //播放列表头部
          Row({ space: 8 }) {
            Row({ space: 8 }) {
              //播放图标
              Row() {
                Image($r('app.media.ic_play'))
                  .width(16)
                  .fillColor('#ff5186')
              }
              .width(50)
              .aspectRatio(1)
              .justifyContent(FlexAlign.Center)

              //播放列表文字
              Row({ space: 8 }) {
                Text(`播放列表(${this.playState.playList.length})`)
                  .fontColor(Color.White)
                  .fontSize(14)
              }
              .layoutWeight(1)

              //隐藏播放列表
              Image($r('app.media.ic_close'))
                .fillColor('#ffa49a9a')
                .width(24)
                .margin({ right: 16 })
                .onClick(() => {
                  this.panelHeight = '0%'
                })
            }
          }
          .width('100%')
          .border({ width: 1, color: '#12ec5c87' })
          .borderRadius({ topLeft: 4, topRight: 4 })

          //播放列表歌曲
          List() {
            ForEach(this.playState.playList, (item: SongItemType, index) => {
              ListItem() {
                Row() {
                  //序号
                  Row() {
                    Text((index + 1).toString())//如果歌曲正在播放,那么响应的颜色需要改变
                      .fontColor(this.playState.playIndex === index ? $r('app.color.primary_light') : "#ffa49a9a")
                  }
                  .width(50)
                  .aspectRatio(1)
                  .justifyContent(FlexAlign.Center)

                  //歌曲信息
                  Row({ space: 10 }) {
                    Column() {
                      Text(item.name)
                        .fontSize(14)//如果歌曲正在播放,那么响应的颜色需要改变
                        .fontColor(this.playState.playIndex === index ? $r('app.color.primary_light') : "#ffa49a9a")
                      Text(item.author)
                        .fontSize(12)//如果歌曲正在播放,那么响应的颜色需要改变
                        .fontColor(this.playState.playIndex === index ? $r('app.color.primary_light') : "#ffa49a9a")
                    }
                    .layoutWeight(1)
                    .alignItems(HorizontalAlign.Start)
                    .justifyContent(FlexAlign.Center)
                  }
                  .layoutWeight(1)
                  .onClick(() => {
                    AVPlayerUtils.SingPlayPlus(item)
                  })

                  //删除歌曲
                  Image($r('app.media.ic_more'))
                    .width(24)
                    .height(24)
                    .margin({ right: 16 })
                    .fillColor(this.playState.playIndex === index ? $r('app.color.primary_light') : "#ffa49a9a")
                }
                .alignItems(VerticalAlign.Center)
              }
              .border({ width: { bottom: 1 }, color: '#12ec5c87' })
            }, (item: number, index) => JSON.stringify(item))
          }
          .layoutWeight(1)
          .backgroundColor('#ff35333')
        }
        .width('100%')
        .height('50%')
        .borderRadius({ topLeft: 10, topRight: 10 })
        .backgroundColor('#ff353333')
      }
      .height(this.panelHeight)
      .visibility(this.panelHeight === '0%' ? Visibility.Hidden : Visibility.Visible)
      .animation({ duration: 500 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Transparent)
    .opacity(this.opacityNum)
  }

  //页面切换转场
  // pageTransition() {
  //   PageTransitionEnter({ duration: 500, curve: Curve.Linear })
  //     .onEnter((type: RouteType, progress: number) => {
  //       this.opacityNum = progress
  //     })
  //   PageTransitionExit({ duration: 500, curve: Curve.Ease })
  //     .onExit((type: RouteType, progress: number) => {
  //       this.opacityNum = progress
  //     })
  // }
}