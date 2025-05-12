import { AVPlayerUtils } from './common/AVPlayerUtils'

@Entry
@Component
struct D0508Page2 {
  @State message:string = ''
  @State message1:string = ''
  build() {
    Column({space:15}){
      Text("当前歌曲总时长：" + this.message)
      Text("当前歌曲时长：" + this.message1)
      Button('播放')
        .onClick(() => {
          const url = 'https://elaina-1017-1331423751.cos.ap-guangzhou.myqcloud.com/AVPlayer/1.mp3'
          AVPlayerUtils.playSingle(url)
          setInterval(() => {
            this.message = JSON.stringify(AVPlayerUtils.duration)
            this.message1 = JSON.stringify(AVPlayerUtils.time)
          },1000)
        })
      Button('暂停播放')
        .onClick(() => {
          AVPlayerUtils.pause()
        })
      Button('恢复播放')
        .onClick(() => {
          AVPlayerUtils.play()
          setInterval(() => {
            this.message = JSON.stringify(AVPlayerUtils.duration)
            this.message1 = JSON.stringify(AVPlayerUtils.time)
          },1000)
        })
      Button('停止播放')
        .onClick(() => {
          AVPlayerUtils.stop()
          setInterval(() => {
            this.message = JSON.stringify(AVPlayerUtils.duration)
            this.message1 = JSON.stringify(AVPlayerUtils.time)
          },1000)
        })
    }
    .width('100%')
    .height('100%')
  }
}