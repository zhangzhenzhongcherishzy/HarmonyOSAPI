import { relationalStore, ValuesBucket } from '@kit.ArkData';

interface predicatesData extends ValuesBucket {
  id: number | null
  username: string,
  email: string,
  age: number,
  created_at: number,
  is_active: number,
}

@Entry
@Component
struct D0414Page1 {
  sql: relationalStore.RdbStore | null = null
  mysql = `CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL UNIQUE,
                email TEXT NOT NULL UNIQUE,
                age INTEGER CHECK(age >= 0),
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                is_active INTEGER DEFAULT 1
            )`

  build() {
    Column({ space: 20 }) {
      Button('创建数据库')
        .onClick(async () => {
          //创建数据库
          this.sql = await relationalStore.getRdbStore(getContext(),
            { name: 'sql', securityLevel: relationalStore.SecurityLevel.S3 })
          AlertDialog.show({
            message: '数据库文件创建成功'
          })
        })
      Button('创建表')
        .onClick(async () => {
          //创建表
          await this.sql?.executeSql(this.mysql)
          AlertDialog.show({
            message: '数据库表创建成功'
          })
        })
      Button('查询表信息')
        .onClick(async () => {
          //获取表名
          const predicates = new relationalStore.RdbPredicates('users')
          //查询表信息
          const resultset = await this.sql?.query(predicates)
          AlertDialog.show({
            message: `${resultset?.columnNames}`
          })
        })
      Button('写入数据')
        .onClick(async () => {
          const result = await this.sql?.insert('users', {
            id: null,
            username: '张振中1',
            email: '763557238@qq.com1',
            age: 181,
            created_at: Date.now(),
            is_active: 0,
          } as predicatesData)
          AlertDialog.show({
            message: `写入成功：${result}`
          })
        })
      Button('查询写入数据')
        .onClick(async () => {
          //获取表名
          const predicates = new relationalStore.RdbPredicates('users')
          //查询表信息
          const resultset = await this.sql?.query(predicates)
          //查询总数
          AlertDialog.show({
            message: `表名：${resultset?.rowCount}`
          })
          let list: predicatesData[] = []
          //查询列表
          while (resultset?.goToNextRow()) {
            const item: predicatesData = {
              id: resultset?.getLong(0),
              username: resultset?.getString(1),
              email: resultset?.getString(2),
              age: resultset?.getLong(3),
              created_at: resultset?.getLong(4),
              is_active: resultset?.getLong(5),
            }
            list.push(item)
          }
          AlertDialog.show({
            message: ` ${JSON.stringify(list)}`
          })
        })

      Button('删除数据')
        .onClick(async () => {
          //获取表名
          const predicates = new relationalStore.RdbPredicates('users')
          predicates.in('id',[1])
          await this.sql?.delete(predicates)
          AlertDialog.show({
            message: ` 删除成功`
          })
        })
      Button('更新数据')
        .onClick(async () => {
          //获取表名
          const predicates = new relationalStore.RdbPredicates('users')
          predicates.equalTo('id',2)
          await this.sql?.update({
            username:'小明1111'
          } as predicatesData,predicates)
          AlertDialog.show({
            message: `更新成功`
          })
        })
      Button('删除数据库')
        .onClick(async () => {
          //删除数据库
          relationalStore.deleteRdbStore(getContext(), 'sql')
          AlertDialog.show({
            message: '数据库文件删除成功'
          })
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f2f3')
  }
}