import { common } from '@kit.AbilityKit';
import { relationalStore, ValuesBucket } from '@kit.ArkData';

export interface predicatesData extends ValuesBucket {
  id: number | null
  username: string,
  email: string,
  age: number,
  created_at: string,
  is_active: number,
}

class predicatesClass {
  private context = getContext() as common.UIAbilityContext //UI上下文
  private tableName = 'users' //数据库表名
  private mysql: relationalStore.RdbStore | null = null //操作数据的实例
  //创建数据库表
  private SQL_CREATE_TABLE = `
                      CREATE TABLE IF NOT EXISTS ${this.tableName} (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        username TEXT NOT NULL UNIQUE,
                        email TEXT NOT NULL UNIQUE,
                        age INTEGER CHECK (age >= 18),
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        is_active INTEGER DEFAULT 1
                      )
                     `

  //获取数据库操作实例
  async getStore() {
    const store = await relationalStore.getRdbStore(this.context, {
      name: 'mysql',
      securityLevel: relationalStore.SecurityLevel.S3
    })
    return store
  }

  //类的构造器
  constructor() {
    this.getStore().then((store) => {
      store.executeSql(this.SQL_CREATE_TABLE)
    })
  }

  //写入数据
  async insert(value: predicatesData) {
    const store = await this.getStore()
    store.insert(this.tableName, value)
  }

  //删除数据
  async delete(value2: string, value3: string | number) {
    const store = await this.getStore()
    let predicates2 = new relationalStore.RdbPredicates(this.tableName);
    predicates2.equalTo(value2, value3)
    await store.delete(predicates2)
  }

  //删除数据库
  async deletemysql() {
    await relationalStore.deleteRdbStore(getContext(), 'mysql').then(() => {
      AlertDialog.show({
        message: '数据库删除成功'
      })
    })
  }

  //更新数据
  async updata(value1:string,value2:number | string,value3:predicatesData) {
    const store = await this.getStore()
    const predicates = new relationalStore.RdbPredicates('users')
    predicates.equalTo(value1,value2)
    await store.update(value3 as predicatesData,predicates)
  }

  //查询数据
  async query() {
    const store = await this.getStore()
    //获取表名
    const predicates = new relationalStore.RdbPredicates('users')
    // predicates.equalTo('id','1')
    //查询表信息
    const resultset = await store.query(predicates)
    let list: predicatesData[] = []
    while (resultset.goToNextRow()) {
      const item: predicatesData = {
        id: resultset.getLong(0) || null,
        username: resultset.getString(1),
        email: resultset.getString(2),
        age: resultset.getLong(3),
        created_at: resultset.getString(4),
        is_active: resultset.getLong(5),
      }
      list.push(item)
    }
    return list
  }
}

export const predicatesStore = new predicatesClass()