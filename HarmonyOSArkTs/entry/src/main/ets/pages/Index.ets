import router from '@ohos.router';

/*
@comp 快捷方式生成结构体
装饰器： 用于装饰类、结构、方法以及变量，并赋予其特殊的含义。如上述示例中@Entry、@Component和@State都是装饰器，@Component表示自定义组件，@Entry表示该自定义组件为入口组件，@State表示组件中的状态变量，状态变量变化会触发UI刷新。
UI描述：以声明式的方式来描述UI的结构，例如build()方法中的代码块。
自定义组件：可复用的UI单元，可组合其他组件，如上述被@Component装饰的struct Index。
系统组件：ArkUI框架中默认内置的基础和容器组件，可直接被开发者调用，比如示例中的Column、Text
属性方法：组件可以通过链式调用配置多项属性，如fontSize()、width()、height()、backgroundColor()等。
事件方法：组件可以通过链式调用设置多个事件的响应逻辑
 */
@Entry//装饰器
@Component//装饰器
struct Index {//自定义组件 struct关键字
  @State message:string = 'hello world' //变量装饰器
  build() {//UI描述
    Column(){//系统组件
      Text(this.message)
        .onClick(() => {//事件方法
          console.log('aaaa');
          this.message = '你好，世界'
          router.pushUrl({
            url:"pages/day20250211/Demo01preview"

          })
          console.log('aaa')
        })
      Row(){

      }
    }
    .width("100%")//属性方法
    .height('100%')//属性方法
  }
}