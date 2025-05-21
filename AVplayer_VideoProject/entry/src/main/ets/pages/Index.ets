import { NavTabsPage } from '../views/NavTabsPage';
import { SearchRow } from '../views/SearchPage';
import { LengthMetrics } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();
  //首页部分底部导航栏 自定义构建函数
  @Builder
  tabBuilder(img: Resource, title: Resource, index: number) {
    Column() {
      Image(img)
        .width(24)
        .height(24)
        .fillColor(this.currentIndex === index ? '#0a59f7' : '#66000000')
      Text(title)
        .margin({ top: '4vp' })
        .fontSize(10)
        .fontWeight(500)
        .fontColor(this.currentIndex === index ? '#0a59f7' : '#66000000')
    }
    .justifyContent(FlexAlign.Center)
    .height('56vp')
    .width('100%')
    .onClick(() => {
      this.currentIndex = index;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      TabContent() {
        Column(){
          //搜索部分
          SearchRow()
          //顶部导航条
          NavTabsPage()
        }
      }
      .tabBar(this.tabBuilder($r('app.media.mine'), $r('app.string.tabBar1'), 0))

      TabContent() {
        Text($r('app.string.tabBar2_content'))
      }
      .tabBar(this.tabBuilder($r('app.media.mine'), $r('app.string.tabBar2'), 1))
      TabContent() {
        Text($r('app.string.tabBar2_content'))
      }
      .tabBar(this.tabBuilder($r('app.media.mine'), $r('app.string.tabBar3'), 2))
      TabContent() {
        Text($r('app.string.tabBar2_content'))
      }
      .tabBar(this.tabBuilder($r('app.media.mine'), $r('app.string.tabBar4'), 3))
    }
    .barHeight(56)
    .barWidth('150%')
    .vertical(false)
    .safeAreaPadding({top:LengthMetrics.vp((AppStorage.get<number>('statusBarHeight') ?? 0)),bottom:LengthMetrics.vp((AppStorage.get<number>('statusBarHeight') ?? 0))})
    .barMode(BarMode.Fixed)
    .onChange((index: number) => {
      this.currentIndex = index;
    })
  }
}