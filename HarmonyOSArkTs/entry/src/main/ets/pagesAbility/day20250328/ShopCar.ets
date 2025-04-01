interface TimeTable {
  title: string;
  projects: string[];
}

@Component
struct ShopItemComp {
  @State value: number = 0

  build() {
    Row() {
      //商品选择
      Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
        .select(true)
        .selectedColor(0xed6f21)
        .shape(CheckBoxShape.CIRCLE)
        .onChange((value: boolean) => {
          console.info('Checkbox1 change is' + value)
        })
      Image($r('app.media.a12'))
        .height('90%')
        .aspectRatio(1)
        .objectFit(ImageFit.Cover)
        .borderRadius(20)
      Column() {
        //商品标题和介绍
        Column() {
          Text('肯德基热销百万主食随心选OK 666')
          Text('免预约')
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        //商品价格和购车商品数量
        Row() {
          Text() {
            Span('￥')
            Span('19.9')
          }

          Counter() {
            Text(this.value.toString())
          }
          .onInc(() => {
            this.value++
          })
          .onDec(() => {
            this.value--
          })

        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
      }
      .layoutWeight(1)
      .height('90%')
      .justifyContent(FlexAlign.SpaceBetween)

    }
    .height(120)
    .backgroundColor(Color.White)
  }
}


@Entry
@Component
struct ShopCar {
  @State message: string = 'Hello World';
  private timeTable: TimeTable[] = [
    {
      title: '肯德基',
      projects: ['语文', '数学', '英语']
    },
    {
      title: '华莱斯',
      projects: ['物理', '化学', '生物']
    },
    {
      title: '马德利蛋糕',
      projects: ['历史', '地理', '政治']
    },
    {
      title: '麦当福',
      projects: ['美术', '音乐', '体育']
    }
  ]

  @Builder
  itemHead(text: string) {
    Text(text)
      .fontSize(20)
      .backgroundColor(0xAABBCC)
      .width("100%")
      .padding(10)
  }

  build() {
    Column() {
      // shopCar-header
      Column({ space: 5 }) {
        Row() {
          Text('购物车')
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
          Button('退出管理')
            .type(ButtonType.Normal)
            .buttonStyle(ButtonStyleMode.TEXTUAL)
            .fontSize(22)
            .borderRadius(10)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Text('全部(33)')
            .fontSize(20)
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
      }
      .width('96%')
      .padding(10)
      .backgroundColor(Color.White)


      // shopCar-content
      List({ space: 20 }) {
        ForEach(this.timeTable, (item: TimeTable) => {
          ListItemGroup({ header: this.itemHead(item.title) }) {
            ForEach(item.projects, (project: string) => {
              ListItem() {
                // Text(project)
                //   .width("100%")
                //   .height(100)
                //   .fontSize(20)
                //   .textAlign(TextAlign.Center)
                //   .backgroundColor(0xFFFFFF)

                ShopItemComp()
              }
            }, (item: string) => item)
          }
          .padding({ bottom: 10, left: 5, right: 5 })
          .backgroundColor(Color.White)
          .width('96%')


          // .divider({ strokeWidth: 1, color: Color.Blue }) // 每行之间的分界线
        })
      }
      .layoutWeight(1)
      .width('100%')
      .alignListItem(ListItemAlign.Center)


      //shopCar-footer

      Row() {
        Row() {
          //全选
          Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
            .select(true)
            .selectedColor(0xed6f21)
            .shape(CheckBoxShape.CIRCLE)
            .onChange((value: boolean) => {
              console.info('Checkbox1 change is' + value)
            })
          Text('全选')
        }

        // 按钮组
        Row() {
          Button('移入收藏')
          Button('删除')
        }

      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding('2%')
      .backgroundColor(Color.White)

    }
    .height('100%')
    .width('100%')
    .backgroundColor("#ffeae8e8")
  }
}