// import { MainPage, add } from 'staticlibraryhar';
// import {adds} from 'sharedlibraryhsp'
import { ToastUtil } from '@pura/harmony-utils';
@Entry
@Component
struct D0312Demo1 {
  @State a: number = 55
  @State b: number = 65
  @State c: number = 0

  build() {
    Column() {
      Button("showToast()")
        .onClick(() => {
          ToastUtil.showToast("弹出土司，默认时长为2s");
        })
      // Text(this.a.toString())
      // Text(this.b.toString())
      // TextInput({ text: JSON.stringify(this.c) })
      // Button('点击求和')
      //   .onClick(() => {
      //     this.c = add(this.a, this.b)
      //   })
      // Button('点击求和1')
      //   .onClick(() => {
      //     this.c = adds(this.a, this.b)
      //   })
      // MainPage()
    }
  }
}