@Entry
@Component
struct D0320Demo1 {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  private arr: number[] = [1, 2, 3];

  @Builder
  PageMap(name: string) {
    if (name === "NavDestinationTitle1") {
      pageOneTmp()
    } else if (name === "NavDestinationTitle2") {
      pageTwoTmp()
    } else if (name === "NavDestinationTitle3") {
      pageThreeTmp()
    }
  }

  build() {
    Navigation(this.pageInfos) {
      TextInput({ placeholder: 'search...' })
        .width("90%")
        .height(40)
        .backgroundColor('#FFFFFF')
      List({ space: 12 }) {
        ForEach(this.arr, (item: number) => {
          ListItem() {
            Text("Page" + item)
              .width("100%")
              .height(72)
              .backgroundColor('#FFFFFF')
              .borderRadius(24)
              .fontSize(16)
              .fontWeight(500)
              .textAlign(TextAlign.Center)
              .onClick(() => {
                this.pageInfos.pushPath({ name: "NavDestinationTitle" + item })
              })
          }
        }, (item: number) => item.toString())
      }
      .width("90%")
      .margin({ top: 12 })
    }
    .title({ main: '主标题', sub: '副标题' })
    .menus([{ value: $r('app.string.test'), icon: $r('app.media.news'), },
      { value: '扫码', icon: $r('app.media.news') }])
    .titleMode(NavigationTitleMode.Mini)
    .navDestination(this.PageMap)
    .toolbarConfiguration([
      { value: '首页', icon: $r("app.media.news"), },
      { value: '个人', icon: $r("app.media.news"), }
    ])
    .mode(NavigationMode.Split)
  }
}

// PageOne.ets
@Builder
export function pageOneTmpBuilder(name: string, param: Object) {
  pageOneTmp()
}
@Component
export struct pageOneTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent1111111111111")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle1")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}

// PageTwo.ets
@Builder
export function pageTwoTmpBuilder(name: string, param: Object) {
  pageTwoTmp()
}
@Component
export struct pageTwoTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent2")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle2")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}

// PageThree.ets
@Builder
export function pageThreeTmpBuilder(name: string, param: Object) {
  pageThreeTmp()
}
@Component
export struct pageThreeTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent3")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle3")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}