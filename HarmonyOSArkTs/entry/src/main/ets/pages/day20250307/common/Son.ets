import {storage} from './Idata'
// let sonmessage:SubscribedAbstractProperty<number> = storage.link('message1')
// sonmessage.set(50)
@Entry(storage)
@Component
export struct Son {
  @LocalStorageLink('message1') sonmessage:number = 0
  @State arr:number[] = [1,2,3,4,5,6]
  build() {
    Column(){
      Button(this.sonmessage.toString())
        .onClick(() => {
          this.sonmessage = this.arr.length
        })
    }
  }
}