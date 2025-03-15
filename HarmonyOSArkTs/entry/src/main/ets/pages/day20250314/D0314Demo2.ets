import { storage } from './D0314Demo1'
@Entry(storage)
@Component
struct D0314Demo2 {
  @LocalStorageLink('user') user: string = ''
  @LocalStorageLink('pass') pass: string = ''
  @State username: string = ''
  @State password: string = ''

  build() {
    Column() {
      TextInput()
        .onChange((value: string) => {
          this.username = value
        })
      TextInput()
        .onChange((value: string) => {
          this.password = value
        })
      Button('登录').onClick(() => {
        if (this.username === this.user && this.password === this.pass) {
          AlertDialog.show({
            message: `正确,
            页面存储账号:${this.user}
            页面存储密码：${this.pass}
            账号:${this.username}
            密码：${this.password} `
          })
        } else {
          AlertDialog.show({
            message: `错误,
            页面存储账号:${this.user}
            页面存储密码：${this.pass}
            账号:${this.username}
            密码：${this.password} `
          })
        }
      })
    }
  }
}