/**
 Copyright 2024 csx - @yunkss/ef_

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
import { rcp } from "@kit.RemoteCommunicationKit";
import { efRcpConfig } from "./efRcpConfig";
import { BusinessError } from "@kit.BasicServicesKit";
import { EfRcpError } from "./EfRcpError";

/**
 * @Author csx
 * @DateTime 2024/11/7 08:01:04
 * @TODO EfCodeInterceptor  系统级别和业务级别编码拦截器
 */
export class EfCodeInterceptor implements rcp.Interceptor {
  /**
   * 编码监听
   */
  private codeEventListener: efRcpConfig.codeEvent;

  constructor(codeEventListener: efRcpConfig.codeEvent) {
    this.codeEventListener = codeEventListener;
  }

  async intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    try {
      //响应对象
      const response = await next.handle(context);
      //无监听则抛出异常
      if (this.codeEventListener) {
        //设置监听
        //1.将响应数据转换成json
        if (response) {
          let code = this.codeEventListener.businessCodeName;
          //如果有业务异常编码code
          if (code) {
            //转换为json字符串
            let resultStr = response.toString();
            if (resultStr) {
              //提取code对应的json
              let jsonFragment = this.extractJsonFragment(resultStr, code);
              if (jsonFragment) {
                //提取code对应的值
                let codeValue = this.getValueFromJsonFragment(jsonFragment, code);
                //传递给回调事件
                this.codeEventListener.listener(response.statusCode, codeValue);
              }
            }
          } else {
            let efRcpError = new EfRcpError(11010, '响应码监听异常',
              '未设置业务编码监听对应的code属性efRcpConfig.codeEvent.businessCodeName~');
            return Promise.reject(efRcpError);
          }
        }
      } else {
        let efRcpError = new EfRcpError(11010, '响应码监听异常',
          '启用响应码监听请设置efRcpConfig.codeEvent属性~');
        return Promise.reject(efRcpError);
      }
      return response;
    } catch (error) {
      let b = error as BusinessError;
      //抛出
      return Promise.reject(b);
    }
  }

  /**
   * 使用正则表达式提取 JSON 片段
   * @param jsonStr  待提取的json字符串
   * @param key  传入的key
   * @returns
   */
  extractJsonFragment(jsonStr: string, key: string): string | null {
    // 构建正则表达式来匹配指定的键及其值
    // 使用非贪婪匹配来处理可能的嵌套情况
    const regex = new RegExp(`"${key}":\\s*"([^"]*)"`, 's');
    const match = jsonStr.match(regex);
    return match ? match[0] : null;
  }

  /**
   * 解析 JSON 片段并提取值
   * @param jsonFragment 提取的json片段
   * @param key  待提取的key
   * @returns
   */
  getValueFromJsonFragment(jsonFragment: string, key: string): Object | null {
    try {
      // 因为 jsonFragment 可能是键值对的一部分，需要添加大括号来形成合法的 JSON
      const fragmentObject: Record<string, Object> = JSON.parse(`{${jsonFragment}}`);
      return fragmentObject[key];
    } catch (error) {
      console.error('提起json的key错误:', error);
      return null;
    }
  }
}