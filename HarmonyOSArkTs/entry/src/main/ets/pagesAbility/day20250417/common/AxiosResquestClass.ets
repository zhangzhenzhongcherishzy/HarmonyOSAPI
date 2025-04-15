import axios, {AxiosError,AxiosInstance,AxiosRequestConfig,AxiosResponse,InternalAxiosRequestConfig} from '@ohos/axios';
import { DialogHelper } from '@pura/harmony-dialog';
import { LogUtil, ToastUtil } from '@pura/harmony-utils';
type axiosMethod = 'get' | 'post' | 'put' | 'delete'
const LOGGER_DOMAIN: number = 0x0000
const LOGGER_TAG: string = '[AxiosRequestC]'
LogUtil.init(LOGGER_DOMAIN, LOGGER_TAG, true)

class AxiosRequestC {
  private static instance: AxiosRequestC;
  private axiosInstance: AxiosInstance;
  private constructor() {
    LogUtil.debug(':constructor')
    this.axiosInstance = axios.create({
      // 使用模拟器需要改为物理机的真实IP地址
      baseURL: 'http://172.20.10.2:8989',
      timeout: 1000,
      headers: { 'Content-Type': 'application/json' }
    });
    // 设置拦截器
    this.interceptorsSet()
  }
  private _isDebug: boolean = true;
  public set isDebug(value: boolean) {
    this._isDebug = value;
  }
  //通过静态方法创建单例对象
  public static getInstance(): AxiosRequestC {
    if (!AxiosRequestC.instance) {
      AxiosRequestC.instance = new AxiosRequestC();
    }
    return AxiosRequestC.instance;
  }
  // 设置拦截（请求拦截和响应拦截）
  public interceptorsSet() {
    // 请求拦截
    this.axiosInstance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
      // TODO： 从appStore 拿到 token，携带到header头
      const tk = AppStorage.get('token') ?? ''
      config.headers.set('token', 'token测试。。。。。' + tk)
      return config;
    }, (error: AxiosError) => {
      // Do something with the request error.
      return Promise.reject(error);
    });
    // 登录接口   一个  token（15分钟 ）   刷新token：作用是可以通过刷新token从新获取一对token值 （15天~30天）
    // 响应拦截
    this.axiosInstance.interceptors.response.use((response: AxiosResponse) => {
      // Do something about the response data.
      if (this._isDebug) {
        LogUtil.debug('########## response.data:')
        LogUtil.debug(JSON.stringify(response.data))
        LogUtil.debug('########## response.status:')
        LogUtil.debug(`${response.status ?? 'statusText为空字符'}`)
        LogUtil.debug('########## response.statusText:')
        LogUtil.debug(response.statusText)
        LogUtil.debug('########## response.headers:')
        LogUtil.print(response.headers)
        LogUtil.debug('########## response.config:')
        LogUtil.print(response.config)
        LogUtil.debug('########## response.request:')
        LogUtil.print(response.request)
        LogUtil.debug('########## response.performanceTiming:')
        LogUtil.print(response.performanceTiming)

        //提示弹出框
        // DialogHelper.showTipsDialog({
        //   content: '网络日志已输出',
        //   onAction: (action) => {
        //     ToastUtil.showToast(`${action}`);
        //   }
        // })

        // DialogHelper.showToast("这是一个自定义吐司")
        DialogHelper.showToastLong("这是一个自定义的长吐司呀")
      }
      return response;
    }, (error: AxiosError) => {
      return Promise.reject(error);
    });
  }
  /**
   *
   * # 泛型 T ：响应数据的类型
   * # 泛型 R ：GET请求的传参类型
   * # 泛型 U ：POST发送数据的类型
   * @param url 接口地址（不包含baseURL）
   * @param method  请求的方法
   * @param params get请求传参
   * @param data POST和PUT payload携带数据
   * @returns Promise对象 成功时返回 AxiosResponse（http响应体）
   */
  service<T, R = null, U = null>(
    url: string,
    method: axiosMethod,
    params?: R,
    data?: U
  ): Promise<AxiosResponse<T, U>> {
    const config: AxiosRequestConfig = {
      url,
      method,
      data,
      params
    }
    return this.axiosInstance.request<T, AxiosResponse<T, U>, U>(config)
  }
}
export default AxiosRequestC