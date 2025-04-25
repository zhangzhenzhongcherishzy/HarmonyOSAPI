// B1Page.ets
@Builder
export function B1PageBuilder() {
  B1Page()
}

@Component
export struct B1Page {
  private imageSrc: Resource = $r('app.media.startIcon');
  private label: string = "B1"
  build() {
    Column() {
      NavDestination() {
        Column() {
          Image(this.imageSrc)
            .objectFit(ImageFit.Contain)
            .height(300)
            .width(300)
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
      }.title(this.label)
    }
  }
}