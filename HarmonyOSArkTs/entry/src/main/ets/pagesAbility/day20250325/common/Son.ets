import {storage} from './Idata'
@Entry(storage)
@Component
export struct Son {
  @LocalStorageLink('bool') sonmessage:boolean = false
  build() {
    Column(){
      Button(this.sonmessage.toString())
        .onClick(() => {
          this.sonmessage = !this.sonmessage
        })
    }
  }
}