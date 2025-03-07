import { ComponentContent } from "@kit.ArkUI";

// @Builder加上@Reusable编译报错,不适用于builder
// @Reusable
@Builder
function buildCreativeLoadingDialog(closedClick: () => void) {
  Crash()
}

@Component
export struct Crash {
  build() {
    Column() {
      Text("Crash")
        .fontSize(12)
        .lineHeight(18)
        .fontColor(Color.Blue)
        .margin({
          left: 6
        })
    }.width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
@Entry
@Component
struct D0307Demo2 {
  @State message: string = 'Hello World';
  private uicontext = this.getUIContext();

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('Index')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          let contentNode = new ComponentContent(this.uicontext, wrapBuilder(buildCreativeLoadingDialog), () => {
          });
          this.uicontext.getPromptAction().openCustomDialog(contentNode);
        })
    }
    .height('100%')
    .width('100%')
  }
}