import { pasteboard, BusinessError } from '@kit.BasicServicesKit';
@Entry
@Component
struct D0408Page3 {
  @State message: string = '';
  build() {
    Column({ space: 20 }) {
      //安全控件 - 粘贴控件
      TextInput({ placeholder: '请输入验证码', text: this.message })
      PasteButton()
        .padding({top: 12, bottom: 12, left: 24, right: 24})
        .onClick((event: ClickEvent, result: PasteButtonOnClickResult) => {
          if (PasteButtonOnClickResult.SUCCESS === result) {
            pasteboard.getSystemPasteboard().getData((err: BusinessError, pasteData: pasteboard.PasteData) => {
              if (err) {
                console.error(`Failed to get paste data. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              // 剪贴板内容为 '123456'。
              this.message = pasteData.getPrimaryText();
            });
          }
        })
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundColor('#f1f2f3')
  }
}