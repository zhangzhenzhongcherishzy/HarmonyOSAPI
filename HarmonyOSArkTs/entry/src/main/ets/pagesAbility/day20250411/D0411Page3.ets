import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';
import { EmitterUtil, LogUtil, StrUtil } from '@pura/harmony-utils';
import emitter from '@ohos.events.emitter';

@Entry
@Component
struct D0411Page1 {
  private context = getContext(this) as common.UIAbilityContext;

  @State message1: string = 'Hello World';
  @State second1:string = '我是传奇'

  onPageShow() {
    this.context.eventHub.on('strings',(data:string,data1:string)=> {
      this.message1 = data + data1
    })
    this.context.eventHub.on('seconds',(data:string,data1:string) => {
      this.second1 = data + data1
    })
  }
  aboutToDisappear() {
    this.context.eventHub.off('strings')
    this.context.eventHub.off('seconds')
  }
  build() {
    Column({space:20}){
      Text(this.message1 + '我是一级组件')
      D0411Page2()
      Button(this.second1)
      Button('跳转至第二个页面')
        .onClick(() => {
          router.pushUrl({
            url:"pagesAbility/day20250411/D0411Page2"
          })
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f2f3')
  }
}
//四级组件
@Component
struct D0411Page4 {
  private context = getContext(this) as common.UIAbilityContext;
  @State message4: string = 'Hello World';

  build() {
    Column({space:20}){
      Text(this.message4 + '我是四级组件')
        .onClick(() => {
          this.message4  = '你好，世界'
          let meeage5 = '你好，美女'
          //无参数
          // this.context.eventHub.emit('strings')
          //一个参数
          // this.context.eventHub.emit('strings',this.message4)
          //两个参数
          this.context.eventHub.emit('strings',this.message4,meeage5)
        })
    }
  }
}
//二级组件
@Component
struct D0411Page2 {
  @State message2: string = 'Hello World';

  build() {
    Column({space:20}){
      Text(this.message2 + '我是二级组件')
      D0411Page3()
    }
  }
}
//三级组件
@Component
struct D0411Page3 {
  @State message3: string = 'Hello World';

  build() {
    Column({space:20}){
      Text(this.message3 + '我是三级组件')
      D0411Page4()
    }
  }
}

