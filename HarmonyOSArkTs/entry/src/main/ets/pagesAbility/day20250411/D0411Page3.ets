import { emitter } from '@kit.BasicServicesKit';

@Entry
@Component
struct D0411Page3 {
  @State message1: string = 'hello world'

  //页面每次显示的生命周期
  onPageShow() {
    // 定义一个eventId为1的事件。
    let event: emitter.InnerEvent = { eventId: 1 };
    emitter.on(event, (data: emitter.EventData) => {
      this.message1 = JSON.stringify(data)
      this.message1 = data.data?.content
    })
  }

  aboutToDisappear() {
    emitter.off(1)
  }

  build() {
    Column({ space: 20 }) {
      Text(this.message1 + '我是一级组件')
      D0411Demo2()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f2f3')
  }
}

//四级组件
@Component
struct D0411Demo4 {
  @State message4: string = 'hello world'

  build() {
    Column({ space: 20 }) {
      Text(this.message4 + '我是四级组件')
        .onClick(() => {
          this.message4 = '你好，美女'
          // 定义一个eventId为1的事件，事件优先级为Low。
          let event: emitter.InnerEvent = {
            eventId: 1,
            priority: emitter.EventPriority.LOW
          };

          let eventData: emitter.EventData = {
            data: {
              content: this.message4,
              id: 1,
              isEmpty: false
            }
          };
          // 发送eventId为1的事件，事件内容为eventData。
          emitter.emit(event, eventData);
        })
    }
    .width('100%')
    .backgroundColor('#f1f2f3')
  }
}

//二级组件
@Component
struct D0411Demo2 {
  @State message2: string = 'hello world'

  build() {
    Column({ space: 20 }) {
      Text(this.message2 + '我是二级组件')
      D0411Demo3()
    }
    .width('100%')
    .backgroundColor('#f1f2f3')
  }
}

//三级组件
@Component
struct D0411Demo3 {
  @State message3: string = 'hello world'

  build() {
    Column({ space: 20 }) {
      Text(this.message3 + '我是三级组件')
      D0411Demo4()
    }
    .width('100%')
    .backgroundColor('#f1f2f3')
  }
}
