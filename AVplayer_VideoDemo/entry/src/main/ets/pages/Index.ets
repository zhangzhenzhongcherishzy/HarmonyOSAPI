import { VideoPlayView } from '../views/VideoPlayView';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      VideoPlayView()

      Scroll() {
        Column() {
          // RelatedListView()
          // CommentsView()
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .padding({ bottom: 16 })

      // BottomView()
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.White)
  }
}