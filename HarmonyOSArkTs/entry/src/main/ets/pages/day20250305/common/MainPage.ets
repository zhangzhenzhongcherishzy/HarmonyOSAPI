
import { MineData } from './Class'
import itemdata from './ItemData'
@Component
export struct MainPage {
  @Builder
  toggles() {
    Toggle({ type: ToggleType.Switch, isOn: false })
  }
  build() {
    Column(){
      //列表区
      List() {
        ForEach(itemdata.getminelist(), (items: MineData) => {
          ListItem() {
            Row() {
              Row({ space: 12 }) {
                Image(items.image).width(22).height(22)
                Text(items.text)
              }
              if (items.other === undefined) {
                MainPageSon()
              } else {
                MainPageSon({
                  images:() => {
                    this.toggles()
                  }
                })
              }
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .padding({ left: 12, right: 22 })
          }
          .height(48)
        })
      }
      .backgroundColor('#fff')
      .borderRadius(16)
      .padding({ top: 4, bottom: 4 })
      .divider({
        //分割线
        strokeWidth: 0.2,
        color: Color.Gray,
        startMargin: 42,
        endMargin: 30
      })
    }
  }
}

@Component
struct MainPageSon {

  @BuilderParam images:() => void = this.imageDefault

  @Builder
  imageDefault(){
    Image($r('app.media.right_grey')).width(12).height(12)
  }
  build() {
    this.images()
  }
}