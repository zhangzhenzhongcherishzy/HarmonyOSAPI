import { PhotoHelper, PickerUtil } from '@pura/harmony-utils/Index';
import { BusinessError } from '@kit.BasicServicesKit';
import { RcpDemo1 } from './common/RcpDemo1';

@Entry
@Component
struct D0422Page1 {
  @State uriStr: string = ''
  build() {
    Column(){
      Button('图片上传')
        .onClick(() => {
          PhotoHelper.select().then((uris) => {
            this.uriStr = `调用相册，返回uris：\n${uris.join('\n')}`;
          }).catch((err: BusinessError) => {
            this.uriStr = `调用相册，异常：\n${JSON.stringify(err)}`;
          });
        })
      RcpDemo1()
    }
    .width('100%')
    .height('100%')
  }
}