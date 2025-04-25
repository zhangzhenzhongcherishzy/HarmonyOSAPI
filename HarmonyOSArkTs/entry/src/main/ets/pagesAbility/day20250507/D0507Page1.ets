interface arrSampleObj{
  label:string,
  pagePath:string
}
@Entry
@Component
struct D0507Page {
  @State arr: number[] = [1, 2, 3];
  @StorageProp('myWidth') myWidth: number = 360;
  pageInfos:NavPathStack = new NavPathStack();
  @State arrSample: arrSampleObj[] = [
    {
      label:'B1',
      pagePath:'B1Page'
    },
    {
      label:'B2',
      pagePath:'B2Page'
    }
  ];

  @Builder NavigationTitle() {
    Column() {
      Text('Sample')
        .fontColor('#000000')
        .fontSize(24)
        .width('100%')
        .height('100%')
        .align(Alignment.BottomStart)
        .margin({left:'5%'})
    }.alignItems(HorizontalAlign.Start)
  }

  build() {
    SideBarContainer() {
      Column() {
        List() {
          ForEach(this.arr, (item: number, index) => {
            ListItem() {
              Text('A' + item)
                .width('100%')
                .height("20%")
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Center)
                .backgroundColor('#66000000')
            }
          })
        }.divider({ strokeWidth: 5, color: '#F1F3F5' })
      }.width('100%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .backgroundColor('#F1F3F5')

      Column() {
        Navigation(this.pageInfos) {
          List() {
            ListItem() {
              Column() {
                ForEach(this.arrSample, (item: arrSampleObj, index) => {
                  ListItem() {
                    Text(item.label)
                      .fontSize(24)
                      .fontWeight(FontWeight.Bold)
                      .backgroundColor('#66000000')
                      .textAlign(TextAlign.Center)
                      .width('100%')
                      .height('30%')
                      .margin({
                        bottom:10
                      })
                  }.onClick(() => {
                    this.pageInfos.clear();
                    this.pageInfos.pushPath({ name: item.pagePath })
                  })
                })
              }
            }.width('100%')
          }
        }
        .mode(NavigationMode.Auto)
        .minContentWidth(360)
        .navBarWidth(240)
        .backgroundColor('#FFFFFF')
        .height('100%')
        .width('100%')
        .hideToolBar(true)
        .title(this.NavigationTitle)
      }.width('100%').height('100%')
    }.sideBarWidth(240)
    .minContentWidth(this.myWidth)
  }
}