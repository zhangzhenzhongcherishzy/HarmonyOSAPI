import playNav from '../components/playNav'
import { tabsData } from '../constants/MusicConstants'
import { EmitEventType, PlayStateModel, PlayStateType, TabClass } from '../models/Index'
import { recommondPage } from './recommondPage'
import { SongListPage } from './SongListPage'
import { router } from '@kit.ArkUI'
import { emitter } from '@kit.BasicServicesKit'

@Entry
@Component
struct Index {
  //当前项
  @State currentName: string = 'recommend'
  //订阅事件 接受广播通知，进行赋值
  @State playState: PlayStateType = new PlayStateModel({} as PlayStateType)

  //底部导航栏 切换功能
  @Builder
  getTabBar(item: TabClass) {
    Column() {
      Row() {
        Image(item.icon)
          .fillColor(item.name === this.currentName ? Color.White : $r('app.color.primary_dark'))
          .width(18)
          .aspectRatio(1)
      }
      .width(22)
      .aspectRatio(1)
      .borderRadius(22)
      .backgroundColor(item.name === this.currentName ? $r('app.color.primary_light') : Color.Transparent)
      .justifyContent(FlexAlign.Center)

      Text(item.title)
        .fontSize(12)
        .fontWeight(400)
        .margin({ top: 5 })
        .fontColor(item.name === this.currentName ? $r('app.color.primary_light') : $r('app.color.primary_dark'))
    }
  }

  //接受订阅事件 更新 playstate
  aboutToAppear() {
    emitter.on({ eventId: EmitEventType.UPDATE_STATE }, (data: emitter.EventData) => {
      if (data.data !== undefined) {
        this.playState = new PlayStateModel(JSON.parse(data.data.playState))
      }
    })
  }

  build() {
    Stack() {
      Stack({ alignContent: Alignment.Bottom }) {
        //第一部分  内容区
        Tabs({ barPosition: BarPosition.End }) {
          //循环渲染内容和底部导航栏
          ForEach(tabsData, (item: TabClass) => {
            TabContent() {
              //导航切换的内容区
              if (item.name == 'recommend') {
                //推荐页
                recommondPage()
              } else if (item.name == 'find') {
                //发现页
                SongListPage()
              } else if (item.name == 'mine') {
                //我的页
              } else {
                //歌曲列表页
              }
            }
            .tabBar(this.getTabBar(item))
            .backgroundColor('#fff')
          })
        }
        .barHeight(60)
        .onChange(index => {
          //做切换功能的name赋值
          this.currentName = tabsData[index].name
        })

        //第二部分  背景播放器控件
        if (this.currentName !== 'mine') {
          playNav({ playState: this.playState })
            .translate({ y: -60 })
            .onClick(() => {
              router.pushUrl({
                url: "pages/playing"
              })
            })
        }
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#fff')
    }
  }
}