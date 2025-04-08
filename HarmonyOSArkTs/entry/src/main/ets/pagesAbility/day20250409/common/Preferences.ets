import { preferences } from '@kit.ArkData';

/**
 *创建持久化仓库，设置持久化数据，读取数据方法
 */
export class PreferencesClass {
  static defaultStore: string = 'family'
  static Token: string = 'token'

  //1、创建仓库
  static getstore(content: Context, storeName: string) {
    const store = preferences.getPreferencesSync(content, { name: storeName || PreferencesClass.defaultStore })
    return store
  }

  //2、给仓库添加数据
  static setToken(context: Context, storeName: string, value: string) {
    //获取创建的仓库
    const store = PreferencesClass.getstore(context, storeName)
    //给仓库添加数据
    store.put(PreferencesClass.Token, value)
    //将数据写入磁盘
    store.flush()
  }

  //3、获取仓库数据
  static getToken(context: Context, storeName: string, Token: string) {
    //获取创建的仓库
    const store = PreferencesClass.getstore(context, storeName)
    //获取需要的数据
    const token = store.getSync(Token || PreferencesClass.Token, '')
    return token
  }
}

const Preferences = new PreferencesClass()
