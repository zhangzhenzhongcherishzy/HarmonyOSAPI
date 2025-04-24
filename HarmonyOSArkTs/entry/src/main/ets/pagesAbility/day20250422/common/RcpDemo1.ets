import { PreferencesUtil, ToastUtil } from "@pura/harmony-utils";
import { efRcp, efRcpClientApi, efRcpConfig, EfRcpError } from 'myrcp';
import { rcp } from "@kit.RemoteCommunicationKit";
import lottie from "@ohos/lottie";

//请求所需接口
export interface IResponse<T = ESObject> {
  code: string;
  data: T;
  msg: string;
}

export interface IPageData<T> {
  list?: T[];
  pageNum: number;
  pageSize: number;
  total: number;
}

export interface RoleListItem {
  code: string;
  createTime: string;
  id: number;
  name: string;
  sort: number;
  status: number;
}

export interface IPostPutRole {
  /**
   * 角色编码
   */
  code?: string;

  /**
   * 数据权限(0:全部数据,1:部门及子部门数据,2:本部门数据,3:本人数据)
   */
  dataScope?: number;

  /**
   * 角色名称
   */
  name?: string;

  /**
   * 排序
   */
  sort?: number;

  /**
   * 角色状态(1-正常；0-停用)
   */
  status?: number;
}

export interface LoginResData {
  accessToken: string;
  refreshToken: string;
}

export interface ILoginRequest {
  /**
   * 密码
   */
  password: string;

  /**
   * 用户名
   */
  username: string;
}

export interface IUserData {
  /**
   * 头像
   */
  avatar: string;
  create_by: number;
  dept_id: number;

  /**
   * 邮箱
   */
  email: string;

  /**
   * 性别
   */
  gender: number;
  id: number;
  is_deleted: number;

  /**
   * 手机号
   */
  mobile: string;

  /**
   * 昵称
   */
  nickname: string;

  /**
   * 密码
   */
  password: string;

  /**
   * 状态
   */
  status: number;
  update_by: number;

  /**
   * 用户名
   */
  username: string;
}

export interface IUploadResData {
  fileExtension: string;
  filePathCos: string;
  fileSize: string;
  fileType: string;
  fileUse: string;
  id: number;
  mineType: string;
  uploadTime: string;
}

export enum ResponseCodes {
  SUCCESS = 2000
}

@Entry
@Component
export struct RcpDemo1 {
  @State message: string = 'efRcp';
  //登录动画str
  @State lottieStr: string = '';
  //新增角色 响应UI刷新字段
  @State postJSONAddRoleResStr: string = ''

  //封装登录动画
  async login(query: ILoginRequest) {
    // setTimeout(() => {
    //   efRcp
    //     .setLottieAnimation((ctx: CanvasRenderingContext2D) => {
    //       lottie.destroy('2016');
    //       lottie.loadAnimation({
    //         container: ctx, // 渲染上下文
    //         renderer: 'canvas', // 渲染方式
    //         loop: true, // 是否循环播放,默认true
    //         autoplay: true, // 是否自动播放，默认true
    //         name: '2016', // 动画名称
    //         contentMode: 'Contain', // 填充的模式
    //         frameRate: 20, //设置animator的刷帧率为20
    //         // animationData: JSON.parse(this.lottieStr)
    //         // imagePath: '', // 加载读取指定路径下的图片资源
    //         // path: 'pages/csx.json', // json路径
    //         // initialSegment: [10, 50]                      // 播放的动画片段
    //       })
    //     });
    //   lottie.play();
    // }, 100)
    //登录


    // efRcp
    //   .enableLogInterceptor()// .addCustomInterceptors([new ResponseCheckTokenInterceptor2(RevalidateTokenRequest.getInstance())])
    //   .setBaseURL('http://192.168.105.144:8989')// .disableLoading()
    //   .enableLottie()
    //     // .disableLoading()
    //   .create()

    let dto = await efRcpClientApi.post<IResponse<LoginResData>>({
      url: '/auth/login',
      query,
      loadingTxt: '正在登录中...'
    });
    this.message = JSON.stringify(dto);
    console.log(">>>>" + dto.data?.code)
    // if (!(dto instanceof EfRcpError) && Number(dto.data?.code) === ResponseCodes.SUCCESS) {
    //   ToastUtil.showToast('登录成功~');
    //   //请求成功后将token存储在efRcpParams.tokenValue
    //   efRcpConfig.token.tokenValue = dto.data?.data.accessToken as string;
    //   efRcpConfig.token.tokenName = "Authorization";
    //   PreferencesUtil.putSync("accessToken", dto.data?.data.accessToken as string);
    //   this.message = JSON.stringify(dto.data);
    //   this.message = JSON.stringify(dto.data?.msg);
    // } else {
    //   this.message = (dto as EfRcpError).toString();
    // }
  }

  //获取用户信息
  async getUserInfo() {
    let dto = await efRcpClientApi.get<IResponse<IUserData>>({
      url: '/users/me',
    });
    this.message = JSON.stringify(dto);
  }

  //刷新token
  async getAuthReToken() {
    // ### 调试第三方仓库代码 end
    let dto = await efRcpClientApi.get<IResponse<LoginResData>>({
      url: '/auth/reToken',
      headers: {
        "accept": "application/json"
      },
      cookies: {
        "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySW5mbyI6eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoiYWRtaW4iLCJuaWNrbmFtZSI6Iuezu-e7n-euoeeQhuWRmGFkbWluIiwiZGVwdElkIjoxLCJyb2xlcyI6IkFETUlOIn0sImlzcyI6ImR5czYyMzAiLCJleHAiOjE3NDA1MzIyNzEsIm5iZiI6MTc0MDUzMTk3MSwiaWF0IjoxNzQwNTMxOTcxfQ.scsf-oDgrPS42PK7j6YfHHh9jSt_kkE006M71pvfZV8",
      }
    });
    if (!(dto instanceof EfRcpError) && Number(dto.data?.code) === ResponseCodes.SUCCESS) {
      ToastUtil.showToast('登录成功~');
      //请求成功后将token存储在efRcpParams.tokenValue
      efRcpConfig.token.tokenValue = dto.data?.data.accessToken as string;
      efRcpConfig.token.tokenName = "Authorization";
      // this.message = JSON.stringify(dto.data);
      this.message = JSON.stringify(dto.data?.msg);

    } else {
      this.message = (dto as EfRcpError).toString();
    }
  }

  //封装获取角色列表
  async getJSONAddRole() {
    let dto = await efRcpClientApi.get<IResponse<string>>({
      url: '/roles/page?pageNum=1&pageSize=100',
    });
    this.postJSONAddRoleResStr = JSON.stringify(dto);
  }

  //新增角色
  async postJSONAddRole(query: IPostPutRole) {
    let dto = await efRcpClientApi.post<IResponse<string>>({
      url: '/roles',
      query
    });
    this.postJSONAddRoleResStr = JSON.stringify(dto);
  }
  build() {
    Scroll() {
      Column({ space: 10 }) {
        Text(this.message)
          .id('RcpDemo3HelloWorld')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
        Image('https://sanjitian-1256310189.cos.ap-chengdu.myqcloud.com/gin_test/2025/02/2025_02_19_15_36_08_2712_2.jpg')
          .width(400)
        Image('file://com.tianqing.zhongyi/data/storage/el2/base/haps/entry/files/screenshot_20250207_160347.jpg')
          .width(100)
        Image('file://com.tianqing.zhongyi/data/storage/el2/base/haps/entry/files/2025_02_20_10_24_23_7758_2.jpeg')
          .width(100)

        //登录动画
        Column() {
          Button('登录获取token-post')
            .onClick(() => {
              this.login({
                "username": "admin",
                "password": "123456"
              })
            })
        }
        .borderWidth(2)
        .padding(5)

        //获取用户信息
        Column() {
          Button('获取用户信息-get')
            .onClick(() => {
              this.getUserInfo()
            })
        }
        .borderWidth(2)
        .padding(5)

        //刷新token
        Column() {
          Button('刷新token')
            .onClick(() => {
              this.getAuthReToken()
            })
        }
        .borderWidth(2)
        .padding(5)

        //获取角色列表
        Column() {
          Button('获取角色列表')
            .onClick(() => {
              this.getJSONAddRole()
            })
          Text(this.postJSONAddRoleResStr)
        }
        .borderWidth(2)
        .padding(5)

        //新增角色
        Column() {
          Button('新增角色')
            .onClick(() => {
              this.postJSONAddRole({
                "name": "大什使9000",
                "code": "9000",
                "sort": 28,
                "status": 37,
                "dataScope": 91
              })
            })
          Text(this.postJSONAddRoleResStr)
        }
        .borderWidth(2)
        .padding(5)
      }
    }
    .height('100%')
    .width('100%')
  }
}