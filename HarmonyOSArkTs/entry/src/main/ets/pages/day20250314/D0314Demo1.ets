import { router } from '@kit.ArkUI'
export let storage:LocalStorage = new LocalStorage()
storage.setOrCreate('user','')
storage.setOrCreate('pass','')
@Entry(storage)
@Component
struct RegiterPage {
  @LocalStorageLink('user') user:string = ''
  @LocalStorageLink('pass') pass:string = ''
  @State username: string = ''
  @State password: string = ''
  build() {
    Column(){
      TextInput()
        .onChange((value:string) => {
          this.username = value
        })
      TextInput()
        .onChange((value:string) => {
          this.password = value
        })
      Button('注册').onClick(() => {
        this.user = this.username
        this.pass = this.password
        router.pushUrl({
          url:"pages/day20250314/D0314Demo2"
        })
      })
    }
  }
}