//第一种
// @Builder
// function MyBuilder(value: string, size: number) {
//   Text(value)
//     .fontSize(size)
// }
// let globalBuilder: WrappedBuilder<[string, number]> = wrapBuilder(MyBuilder);

//第二种  @Builder方法赋值给变量在UI语法中使用
// @Builder
// function MyBuilder(value: string, size: number) {
//   Text(value)
//     .fontSize(size)
// }
// @Builder
// function YourBuilder(value: string, size: number) {
//   Text(value)
//     .fontSize(size)
//     .fontColor(Color.Pink)
// }
// const builderArr: WrappedBuilder<[string, number]>[] = [wrapBuilder(MyBuilder), wrapBuilder(YourBuilder)];

//第三种 引用传递 通过按引用传递的方式传入参数，会触发UI的刷新。
// class Tmp {
//   paramA2: string = 'hello';
// }
// @Builder function overBuilder(param: Tmp) {
//   Column(){
//     Text(`wrapBuildervalue:${param.paramA2}`)
//   }
// }
// const wBuilder: WrappedBuilder<[Tmp]> = wrapBuilder(overBuilder);
//第四 常见问题重复定义wrapBuilder失效
@Builder
function MyBuilderFirst(value: string, size: number) {
  Text('MyBuilderFirst：' + value)
    .fontSize(size)
}
@Builder
function MyBuilderSecond(value: string, size: number) {
  Text('MyBuilderSecond：' + value)
    .fontSize(size)
}
interface BuilderModel {
  globalBuilder: WrappedBuilder<[string, number]>;
}
@Entry
@Component
struct D0307Demo1 {
  //第一种
  // @State message: string = 'Hello World';
  //第二种  @Builder方法赋值给变量在UI语法中使用
  // @Builder
  // testBuilder() {
  //   ForEach(builderArr, (item: WrappedBuilder<[string, number]>) => {
  //     item.builder('Hello World', 30)
  //   })
  // }
  //第三种 引用传递 通过按引用传递的方式传入参数，会触发UI的刷新。
  // @State label: Tmp = new Tmp();
  //第四 常见问题重复定义wrapBuilder失效
  @State message: string = 'Hello World';
  @State builderObj: BuilderModel = { globalBuilder: wrapBuilder(MyBuilderFirst) };
  aboutToAppear(): void {
    setTimeout(() => {
      // wrapBuilder(MyBuilderSecond) 不会生效
      this.builderObj.globalBuilder = wrapBuilder(MyBuilderSecond);
    },1000)
  }
  build() {
    Row() {
      Column() {
        //第一种
        // globalBuilder.builder(this.message, 50)
        //第二种  @Builder方法赋值给变量在UI语法中使用
        // this.testBuilder()
        //第三种 引用传递 通过按引用传递的方式传入参数，会触发UI的刷新。
        // wBuilder.builder({paramA2: this.label.paramA2})
        // Button('Click me').onClick(() => {
        //   this.label.paramA2 = 'ArkUI';
        // })
        //第四 常见问题重复定义wrapBuilder失效
        this.builderObj.globalBuilder.builder(this.message, 20)
      }
      .width('100%')
    }
    .height('100%')
  }
}