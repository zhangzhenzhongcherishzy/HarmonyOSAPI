// 引入包名
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import {ResType,PageDataType,RolesType} from './utils/resType'

@Entry
@Component
struct D0415Page1 {
  build() {
    Column({ space: 5 }) {
      Button('下载文件')
        .onClick(() => {
          //创建http实例对象
          let httpRequest = http.createHttp();
          // 用于订阅HTTP响应头事件 应答数据
          httpRequest.on('headersReceive', (header: Object) => {
            //先获取资源长度，在发起请求
            let record = header as Record<string,object>
            let contentlen = record['content-length']
            console.log(">>>" + JSON.stringify(contentlen))
          });
          // 用于订阅HTTP流式响应数据接收事件
          httpRequest.on('dataReceive', (data: ArrayBuffer) => {
            console.info('>>>' + JSON.stringify(data.byteLength));
          });
          // 用于订阅HTTP流式响应数据接收完毕事件
          httpRequest.on('dataEnd', () => {
            console.info('>>>文件读取完毕');
          });
          httpRequest.requestInStream('https://httpbin.org/image/jpeg').then((data) => {
            console.log('>>>' + data);
          }).catch((error:Error) => {
            console.log('>>>' + error.message)
          }).finally(() => {
            httpRequest.off('headersReceive')
            httpRequest.destroy()
          })
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f2f3')
  }
}