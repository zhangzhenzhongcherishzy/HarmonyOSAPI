import { AVPlayerUtils } from './common/AVPlayerUtils';
import { AVRecordUtils } from './common/AVRecorderUtils';
import { fileIo as fs } from '@kit.CoreFileKit';
@Entry
@Component
struct D0508Page3 {
  @State message: string = 'Hello World';
  avUtils = new AVRecordUtils()
  build() {
    Column({space:15}){
      Text(this.message)
        .id('MusicPlayPageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Button('录制')
        .onClick(async () => {
          await this.avUtils.startRecordingProcess()
        })
      Button('暂停')
        .onClick(async () => {
          await this.avUtils.pauseRecordingProcess()
        })
      Button('恢复')
        .onClick(async () => {
          await this.avUtils.resumeRecordingProcess()
        })
      Button('停止')
        .onClick(async () => {
          await this.avUtils.stopRecordingProcess()
        })
      Button('播放')
        .onClick(async () => {
          //找到本地文件路径
          const path = getContext(this).filesDir + 'test-AV.wav'
          let file = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
          let fileFd = 'fd://' + file.fd
          AVPlayerUtils.playSingle(fileFd)
        })
    }
    .height('100%')
    .width('100%')
  }
}