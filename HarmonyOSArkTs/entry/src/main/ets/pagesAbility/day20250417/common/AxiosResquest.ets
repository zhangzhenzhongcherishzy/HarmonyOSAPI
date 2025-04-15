import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';

const BASE_URL: string = 'http://172.20.10.2:8989'
const instance = axios.create({
  baseURL: BASE_URL,
  timeout: 1000,
  headers: { 'Content-Type': 'application/json' }
});
type axiosMethod = 'get' | 'post' | 'put' | 'delete'
// 请求拦截
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // TODO： 从appStore 拿到 token，携带到header头
  const tk = AppStorage.get('token') ?? ''
  config.headers.set('token', 'token测试。。。。。' + tk)
  return config;
}, (error: AxiosError) => {
  return Promise.reject(error);
});
// 响应拦截
instance.interceptors.response.use((response: AxiosResponse) => {
  // Do something about the response data.
  // console.log(`debug:AxiosResponse:${JSON.stringify(response.data)}`)
  console.log(`debug:AxiosResponse:${JSON.stringify(response.status)}`)
  // console.log(`debug:AxiosResponse:${JSON.stringify(response.statusText)}`)
  // console.log(`debug:AxiosResponse:${JSON.stringify(response.headers)}`)
  // console.log(`debug:AxiosResponse:${JSON.stringify(response.config)}`)
  // console.log(`debug:AxiosResponse:${JSON.stringify(response.request)}`)
  // console.log(`debug:AxiosResponse:${JSON.stringify(response.performanceTiming)}`)
  return response;
}, (error: AxiosError) => {
  return Promise.reject(error);
});

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
export function service<T = null, R = null, U = null>(url: string, method: axiosMethod, params?: R, data?: U): Promise<AxiosResponse<T, U>> {
  // const config: AxiosRequestConfig = {
  //   url,
  //   method,
  //   data,
  //   params
  // }
  return instance.request<T, AxiosResponse<T, U>, U>({
      url,
      method,
      data,
      params
  })
}