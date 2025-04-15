// 引入包名
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import {ResType,PageDataType,RolesType} from './utils/resType'

@Entry
@Component
struct D0415Page1 {
  @State message:RolesType[] = []
  //get请求
  async HttpGet() {
    //创建http实例对象
    let httpRequest = http.createHttp();
    // 用于订阅HTTP响应头事件 应答数据
    httpRequest.on('headersReceive', (header: Object) => {
      console.info('header: ' + JSON.stringify(header));
    });
    //发送请求
    let url = 'http://192.168.16.133:8989/roles/page?pageNum=1&pageSize=100' //请求地址
    let option: http.HttpRequestOptions = {
      method: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
      header: {
        'Content-Type': 'application/json'
      }
    }
    await httpRequest.request(url, option).then((res:http.HttpResponse) => {
      //最终应答结果的处理
      // let result:ResType<PageDataType<RolesType[]>> = res.result
      // this.message = JSON.parse(res.result as string)
      let itemdata:ResType<PageDataType<RolesType>> = JSON.parse(res.result as string)
      this.message = itemdata.data.list
      console.log('>>>' + JSON.stringify(this.message))
      AlertDialog.show({
        message:`${JSON.stringify(res.result)}`
      })
    }).catch((error:Error) => {
      AlertDialog.show({
        message:`${error.message}`
      })
    }).finally(() => {
      //善后操作
      httpRequest.off('headersReceive')//取消监听
      httpRequest.destroy()//销毁http请求
    })
  }
  //post请求
  async HttpPost(value:RolesType){
    //创建http实例对象
    let httpRequest = http.createHttp();
    // 用于订阅HTTP响应头事件 应答数据
    httpRequest.on('headersReceive', (header: Object) => {
      console.info('header: ' + JSON.stringify(header));
    });
    //发送请求
    let url = 'http://192.168.16.133:8989/roles' //请求地址
    let option: http.HttpRequestOptions = {
      method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
      header: {
        'Content-Type': 'application/json'
      },
      extraData:value
    }
    await httpRequest.request(url, option).then((res:http.HttpResponse) => {
      //最终应答结果的处理
      // let itemdata:ResType<PageDataType<RolesType>> = JSON.parse(res.result as string)
      // this.message = itemdata.data.list
      AlertDialog.show({
        message:`添加成功：${JSON.stringify(res.result)}`
      })
      console.log('>>>' + res.result)
    }).catch((error:Error) => {
      console.error('请求报错：'+ error.message)
    }).finally(() => {
      httpRequest.off('headersReceive')//取消监听
      httpRequest.destroy()//销毁http请求
    })
  }

  build() {
    Scroll(){
      Column({ space: 10 }) {
        Button('发送http GET请求')
          .onClick(() => {
            this.HttpGet()
          })
        Button('添加数据')
          .onClick(() => {
            let row:RolesType = {
              name: '孙悟空',
              code: '赛亚人',
              sort: 2,
              status: 1,
            }
            this.HttpPost(row)
          })
        ForEach(this.message,(item:RolesType) => {
          Row(){
            Text(item.id?.toString())
              .fontSize(12)
              .padding(12)
              .border({
                width:3,
                color:Color.Red,
                style:BorderStyle.Solid
              })
            Text(item.name)
              .fontSize(12)
              .padding(12)
              .border({
                width:3,
                color:Color.Red,
                style:BorderStyle.Solid
              })
          }
        })
      }
      .width('100%')
      // .height('100%')
      .backgroundColor('#f1f2f3')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f2f3')
  }
}