import { storage } from './Idata'
import { Son } from './Son'

@Entry(storage)
@Component
struct father {
  @LocalStorageLink('message1') fathermessage: number = 0

  build() {
    Column() {
      Button(this.fathermessage.toString())
      Son()
      fatherson({ fathersonmessage: this.fathermessage })
    }
  }
}

@Component
struct fatherson {
  @Link fathersonmessage: number

  build() {
    Column() {
      Button(this.fathersonmessage.toString())
        .onClick((event: ClickEvent) => {
          this.fathersonmessage = 100
        })
    }
  }
}

