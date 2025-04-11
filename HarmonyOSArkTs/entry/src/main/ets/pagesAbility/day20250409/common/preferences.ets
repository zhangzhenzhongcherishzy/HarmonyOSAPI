import { preferences } from '@kit.ArkData';
// /**
//  * 用户首选项:唤醒仓库工具(创建用户首选项实例) --- 写入数据到磁盘中 --- 存储到磁盘 --- 读取磁盘数据 --- 从磁盘删除数据
//  * 可以做：登录状态的存储 app图片的存储和持久化
//  */
// //1、创建用户首选项仓库
// const store = preferences.getPreferencesSync(getContext(),{name:'Gitee'})
//
// //2、往仓库里面添加数据
// if (store.hasSync('token')) {
//   console.info(">>>The key 'token' is contained.");
// }else {
//   console.info("The key 'token' does not contain.");
//   store.putSync('token','token')
//   // 当字符串有特殊字符时，需要将字符串转为Uint8Array类型再存储
//   // let uInt8Array1 = new util.TextEncoder().encodeInto("~！@#￥%……&*（）——+？");
//   // dataPreferences.putSync('uInt8', uInt8Array1);
// }
// //3、存储到磁盘
// store.flush()
//
// //4、读取持久化的数据
// const  item = store.getSync('token','')
//
// //5、删除持久化数据
// store.delete('token')
/**
 * 封装用户首选项工具
 */
export class preferencesClass {
  static defaultStore: string = 'family'
  static Token: string = 'token'

  //1、创建用户首选项
  static createstore(context: Context, storename: string) {
    const store = preferences.getPreferencesSync(context, { name: storename || preferencesClass.defaultStore })
    return store
  }

  //2、往仓库中添加数据
  static addtoken(context: Context, storename: string, value: string | number) {
    const store = preferencesClass.createstore(context, storename) //2-1、调用用户首选项实例
    //2-2 判断有无token字段 如果有，打印即可，如果没有就存储
    store.putSync(preferencesClass.Token, value) //写入存储
    store.flush() // 2-3、储存到磁盘
  }

  //3、获取持久化数据
  static gettoken(context: Context, storename: string, Token: string) {
    const store = preferencesClass.createstore(context, storename) //3-1、调用用户首选项实例
    //获取token
    const token = store.getSync(Token || preferencesClass.Token, '')
    return token
  }

  //4、删除持久化工具
  static delecttoken(context: Context, storename: string, Token: string) {
    const store = preferencesClass.createstore(context, storename) //4-1、调用用户首选项实例
    store.deleteSync(preferencesClass.Token || Token) //删除磁盘持久化
    // preferences.deletePreferences(context,storename)
    store.flush()
  }

  //5、获取所有持久化数据
  static getAllToken(context: Context, storename: string) {
    const store = preferencesClass.createstore(context, storename) //4-1、调用用户首选项实例
    let value = store.getAllSync();
    let allKeys = preferencesClass.getObjKeys(value);
    return allKeys
  }

  // //6、封装获取所有数据方法
  static getObjKeys(obj: Object): string[] {
    let keys = Object.keys(obj);
    return keys;
  }
}