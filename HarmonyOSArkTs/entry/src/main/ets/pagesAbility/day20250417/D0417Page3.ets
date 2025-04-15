import { rcp } from '@kit.RemoteCommunicationKit';
import { BusinessError } from '@kit.BasicServicesKit';

import Logger from './common/logger'


export interface IRolesRequestBody {
  /**
   * 角色编码
   */
  code: string;

  /**
   * 数据权限(0:全部数据,1:部门及子部门数据,2:本部门数据,3:本人数据)
   */
  dataScope: number;

  /**
   * 角色ID
   */
  id?: number;

  /**
   * 角色名称
   */
  name: string;

  /**
   * 排序
   */
  sort: number;

  /**
   * 角色状态(1-正常；0-停用)
   */
  status: number;
}


interface IRoleStatus {
  status: number
}


// 定义自定义响应处理程序
const customHttpEventsHandler: rcp.HttpEventsHandler = {
  // onDataReceive: (incomingData: ArrayBuffer) => {
  //   // 用于处理传入数据的自定义逻辑
  //   // Logger.info('Received data:', JSON.stringify(incomingData));
  //   // return incomingData.byteLength;
  //   const uint8Array = new Uint8Array(incomingData);
  //   // 将 ArrayBuffer 转换为普通数组
  //   const normalArray = Array.from(uint8Array);
  //   // 将数组转换为 JSON 字符串
  //   const jsonString = JSON.stringify({ data: normalArray });
  //   console.log(`onDataReceive: ${jsonString}`);
  // },
  onHeaderReceive: (headers: rcp.RequestHeaders) => {
    // 处理响应头的自定义逻辑
    Logger.info('处理响应头的自定义逻辑 Received headers:', JSON.stringify(headers));
  },
  onDataEnd: () => {
    // 用于处理数据传输完成的自定义逻辑
    Logger.info('Data transfer complete');
  }
};


// 配置跟踪设置
const tracingConfig: rcp.TracingConfiguration = {
  verbose: false,
  infoToCollect: {
    incomingHeader: false, // 接收到的响应头
    outgoingHeader: false, // 发送请求头
    incomingData: false, // 响应体
    outgoingData: false // 请求体
  },
  collectTimeInfo: false,
  httpEventsHandler: customHttpEventsHandler
};


const securityConfig: rcp.SecurityConfiguration = {
  tlsOptions: {
    tlsVersion: 'TlsV1.3'
  }
};

const session = rcp.createSession({ requestConfiguration: { tracing: tracingConfig } });

// const session = rcp.createSession({ requestConfiguration: { tracing: tracingConfig, security: securityConfig } });

// const session = rcp.createSession();

@Entry
@Component
struct RcpDemo1 {
  @State message: string = 'Rcp-fetch';

  // 新增角色
  fetchPostRoles(reqData: IRolesRequestBody) {
    // 定义头信息，其他参数请看API参考
    const requestHeaders: rcp.RequestHeaders = {
      'accept': 'application/json'
    }

    // 定义requestContent，请求部分的正文内容
    const requestContent: rcp.RequestContent = reqData

    let req =
      new rcp.Request("http://192.168.20.98:8989/roles",
        "POST", requestHeaders, requestContent);
    session.fetch(req).then((response) => {
      console.log(`response# ${response}`)
      console.log(`response.toString# ${response.toString()}`)
      console.log(`response.JSON.stringify(response.request)# ${JSON.stringify(response.request)}`)

      console.log(`response.statusCode# ${response.statusCode}`)
      console.log(`response.ResponseHeaders# ${JSON.stringify(response.headers)}`)
      console.log(`response.timeInfo# ${JSON.stringify(response.timeInfo)}`)

      console.log(`response.debugInfo# ${JSON.stringify(response.debugInfo)}`)
      console.log(`response.body# ${JSON.stringify(response.body)}`)


    }).catch((err: BusinessError) => {
      console.error(`err: err code is ${err.code}, err message is ${JSON.stringify(err)}`);
    });
  }

  // 修改角色
  fetchPutRoles(reqData: IRolesRequestBody) {

    // 定义头信息，其他参数请看API参考
    const requestHeaders: rcp.RequestHeaders = {
      'accept': 'application/json'
    }

    // 定义requestContent，请求部分的正文内容
    const requestContent: rcp.RequestContent = reqData

    let req =
      new rcp.Request("http://192.168.20.98:8989/roles/1017",
        "PUT", requestHeaders, requestContent);
    session.fetch(req).then((response) => {
      console.log(`response# ${response}`)
      console.log(`response.toString# ${response.toString()}`)
      console.log(`response.JSON.stringify(response.request)# ${JSON.stringify(response.request)}`)

      console.log(`response.statusCode# ${response.statusCode}`)
      console.log(`response.ResponseHeaders# ${JSON.stringify(response.headers)}`)
      console.log(`response.timeInfo# ${JSON.stringify(response.timeInfo)}`)

      console.log(`response.debugInfo# ${JSON.stringify(response.debugInfo)}`)
      console.log(`response.body# ${JSON.stringify(response.body)}`)

    }).catch((err: BusinessError) => {
      console.error(`err: err code is ${err.code}, err message is ${JSON.stringify(err)}`);
    });
  }

  // 修改角色状态
  fetchPatchRolesStatus(status: number) {

    // 定义头信息，其他参数请看API参考
    const requestHeaders: rcp.RequestHeaders = {
      'accept': 'application/json'
    }

    let req =
      new rcp.Request(`http://192.168.20.98:8989/roles/1017/status?status=${status}`,
        "PATCH", requestHeaders);
    session.fetch(req).then((response) => {
      console.log(`response# ${response}`)
      console.log(`response.toString# ${response.toString()}`)
      console.log(`response.JSON.stringify(response.request)# ${JSON.stringify(response.request)}`)

      console.log(`response.statusCode# ${response.statusCode}`)
      console.log(`response.ResponseHeaders# ${JSON.stringify(response.headers)}`)
      console.log(`response.timeInfo# ${JSON.stringify(response.timeInfo)}`)

      console.log(`response.debugInfo# ${JSON.stringify(response.debugInfo)}`)
      console.log(`response.body# ${JSON.stringify(response.body)}`)

    }).catch((err: BusinessError) => {
      console.error(`err: err code is ${err.code}, err message is ${JSON.stringify(err)}`);
    });
  }

  // 修改角色状态
  fetchPatchRolesStatus2() {

    // 定义头信息，其他参数请看API参考
    const requestHeaders: rcp.RequestHeaders = {
      'accept': 'application/json'
    }

    // 定义要修改的内容
    let modifiedContent: IRoleStatus = {
      status: 5
    };

    let req =
      new rcp.Request(`http://192.168.20.98:8989/roles/1017/status`,
        "PATCH", requestHeaders, modifiedContent);
    session.fetch(req).then((response) => {
      console.log(`response# ${response}`)
      console.log(`response.toString# ${response.toString()}`)
      console.log(`response.JSON.stringify(response.request)# ${JSON.stringify(response.request)}`)

      console.log(`response.statusCode# ${response.statusCode}`)
      console.log(`response.ResponseHeaders# ${JSON.stringify(response.headers)}`)
      console.log(`response.timeInfo# ${JSON.stringify(response.timeInfo)}`)

      console.log(`response.debugInfo# ${JSON.stringify(response.debugInfo)}`)
      console.log(`response.body# ${JSON.stringify(response.body)}`)

    }).catch((err: BusinessError) => {
      console.error(`err: err code is ${err.code}, err message is ${JSON.stringify(err)}`);
    });
  }

  // 删除角色
  fetchDelRoles(rolesId: string) {

    // 定义头信息，其他参数请看API参考
    const requestHeaders: rcp.RequestHeaders = {
      'accept': 'application/json'
    }

    let req =
      new rcp.Request(`http://192.168.20.98:8989/roles/${rolesId}`,
        "DELETE", requestHeaders);
    session.fetch(req).then((response) => {
      console.log(`response# ${response}`)
      console.log(`response.toString# ${response.toString()}`)
      console.log(`response.JSON.stringify(response.request)# ${JSON.stringify(response.request)}`)

      console.log(`response.statusCode# ${response.statusCode}`)
      console.log(`response.ResponseHeaders# ${JSON.stringify(response.headers)}`)
      console.log(`response.timeInfo# ${JSON.stringify(response.timeInfo)}`)

      console.log(`response.debugInfo# ${JSON.stringify(response.debugInfo)}`)
      console.log(`response.body# ${JSON.stringify(response.body)}`)

    }).catch((err: BusinessError) => {
      console.error(`err: err code is ${err.code}, err message is ${JSON.stringify(err)}`);
    });
  }

  build() {
    Column({ space: 10 }) {
      Text(this.message)
        .id('RcpDemo1HelloWorld')
        .fontSize(33)
        .fontWeight(FontWeight.Bold)

      Button('fetch-GET')
        .onClick(() => {

          // 定义请求头
          let headers: rcp.RequestHeaders = {
            'accept': 'application/json'
          };

          let req =
            new rcp.Request("http://192.168.20.98:8989/roles/page?keywords=%E7%AE%A1%E7%90%86%E5%91%98&pageNum=1&pageSize=10",
              "GET", headers);
          session.fetch(req).then((response) => {
            console.log(`response# ${response}`)
            console.log(`response.toString# ${response.toString()}`)
            console.log(`response.JSON.stringify(response.request)# ${JSON.stringify(response.request)}`)

            console.log(`response.statusCode# ${response.statusCode}`)
            console.log(`response.ResponseHeaders# ${JSON.stringify(response.headers)}`)
            console.log(`response.timeInfo# ${JSON.stringify(response.timeInfo)}`)

            console.log(`response.debugInfo# ${JSON.stringify(response.debugInfo)}`)
            console.log(`response.body# ${JSON.stringify(response.body)}`)


          }).catch((err: BusinessError) => {
            console.error(`err: err code is ${err.code}, err message is ${JSON.stringify(err)}`);
          });
        })


      Button('fetch-POST')
        .onClick(() => {
          this.fetchPostRoles({
            "name": "大什使89892",
            "code": "89892",
            "sort": 28,
            "status": 1,
            "dataScope": 1
          })
        })


      Button('fetch-PUT')
        .onClick(() => {
          this.fetchPutRoles({
            "name": "大什使999",
            "code": "999",
            "sort": 28,
            "status": 9,
            "dataScope": 1
          })

        })


      Button('fetch-patch')
        .onClick(() => {
          this.fetchPatchRolesStatus(2)

        })


      Button('fetch-delete')
        .onClick(() => {
          this.fetchDelRoles('1017')

        })


      Button('fetch-patch2')
        .onClick(() => {
          this.fetchPatchRolesStatus2()

        })


    }
    .height('100%')
    .width('100%')
  }
}