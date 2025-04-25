// B2Page.ets
@Builder
export function B2PageBuilder() {
  B2Page()
}
@Component
export struct B2Page {
  private imageSrc: Resource = $r('app.media.startIcon');
  private label: string = "B2"
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