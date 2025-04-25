import fs from '@ohos.file.fs';
import { rcp } from '@kit.RemoteCommunicationKit';
import { BusinessError } from '@kit.BasicServicesKit';
@Entry
@Component
struct D0506Page1 {
  //连接、通讯历史记录
  @State msgHistory: string = ''
  @State downloadUrl: string = "http://192.168.105.103:8989/downloadFiles/2025_02_20_10_24_23_7758_2.jpeg"
  scroller: Scroller = new Scroller()
  build() {
    Row() {
      Column() {
        Text("RCP下载文件示例")
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text("文件地址：")
            .fontSize(14)
            .width(80)
            .flexGrow(0)

          TextInput({ text: this.downloadUrl })
            .onChange((value) => {
              this.downloadUrl = value
            })
            .width(110)
            .fontSize(11)
            .flexGrow(1)
        }
        .width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
          Button("下载到文件")
            .onClick(() => {
              this.download2File()
            })
            .width(110)
            .fontSize(14)

          Button("下载到流")
            .onClick(() => {
              this.download2Stream()
            })
            .width(100)
            .fontSize(14)
        }
        .width('100%')
        .padding(10)

        Scroll(this.scroller) {
          Text(this.msgHistory)
            .textAlign(TextAlign.Start)
            .padding(10)
            .width('100%')
            .backgroundColor(0xeeeeee)
        }
        .align(Alignment.Top)
        .backgroundColor(0xeeeeee)
        .height(300)
        .flexGrow(1)
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .scrollBarWidth(20)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height('100%')
    }
    .height('100%')
  }

  //下载到文件
  download2File() {
    let localFilePath = getContext(this).tempDir + "/2025_02_19_15_36_08_2712_2.jpg"

    let downloadToFile: rcp.DownloadToFile = {
      kind: 'file',
      file: localFilePath,
      keepLocal: false
    } as rcp.DownloadToFile

    const session = rcp.createSession();
    session.downloadToFile(this.downloadUrl, downloadToFile).then((Response) => {
      console.log('res:' + Response.toString())
      this.msgHistory += "下载成功\r\n"
      this.showFileContent(localFilePath)
    }).catch((err: BusinessError) => {
      this.msgHistory += `下载失败, err.code = ${err.code}, err.message = ${err.message}\r\n`;
    });
  }

  //下载到流
  download2Stream() {
    let localFilePath = getContext(this).tempDir + "/demo.txt"
    let fileStream = fs.createStreamSync(localFilePath, "w")
    const streamData: rcp.SyncWriteStream = {
      writeSync(buffer: ArrayBuffer) {
        fileStream.writeSync(buffer)
      }
    };

    let downloadToStream: rcp.DownloadToStream = {
      kind: 'stream',
      stream: streamData, //这里stream属性传递fileStream或者streamData都可以运行成功
    } as rcp.DownloadToStream

    const session = rcp.createSession();
    session.downloadToStream(this.downloadUrl, downloadToStream).then(() => {
      fileStream.flushSync()
      fileStream.closeSync()
      this.msgHistory += "下载成功\r\n"
      this.showFileContent(localFilePath)
    }).catch((err: BusinessError) => {
      this.msgHistory += `下载失败, err.code = ${err.code}, err.message = ${err.message}\r\n`;
    });
  }

  //显示指定文件的内容
  showFileContent(filePath: string) {
    let content = fs.readTextSync(filePath)
    this.msgHistory += "下载文件内容：" + content + "\r\n"
  }
}