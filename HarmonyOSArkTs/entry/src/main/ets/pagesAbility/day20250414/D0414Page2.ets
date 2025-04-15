import { predicatesData, predicatesStore } from './common/predicatesClass'
import { relationalStore } from '@kit.ArkData'

@Entry
@Component
struct D0414Page2 {
  @State message:predicatesData[] = []
  // async onPageShow() {
  //   this.message  = await predicatesStore.query()
  // }
  build() {
    Column({ space: 20 }) {
      Button('写入数据')
        .onClick(async () => {
          await predicatesStore.insert({
            id: null,
            username: '张振中111',
            email: '763557238@qq.com111',
            age: 18111,
            created_at: `${new Date()}`,
            is_active: 1
          })
          AlertDialog.show({
            message:`添加数据成功`
          })
        })
      Button('删除数据')
        .onClick(async () => {
          await predicatesStore.delete('id',3)
          AlertDialog.show({
            message:`删除数据成功`
          })
        })
      Button('更新数据')
        .onClick(async () => {
          let item:predicatesData= {
            id:3,
            username: '小明11',
            email: '763557238@qq.com111',
            age: 1811,
            created_at: `${new Date()}`,
            is_active: 0
          }
          await predicatesStore.updata('id',3, item)
          AlertDialog.show({
            message:`更新数据成功`
          })
        })
      Button('删除数据库')
        .onClick(async () => {
          await predicatesStore.deletemysql()
        })
      //查询数据库
      // Button('查询写入数据')
      //   .onClick(async () => {
      //     const result = await predicatesStore.query()
      //     AlertDialog.show({
      //       message:`查询数据成功：${JSON.stringify(result)}`
      //     })
      //   })
      ForEach(this.message,(item:predicatesData) => {
        mysqlSon({item:item})
      })
      Button('删除数据库')
        .onClick(async () => {
          //删除数据库
          relationalStore.deleteRdbStore(getContext(), 'mysql')
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

@Component
struct mysqlSon{
  @Prop item:predicatesData
  build() {
    Column({space:5}){
      Text('id：' + this.item.id)
      Text('username：' + this.item.username)
      Text('email：' + this.item.email)
      Text('age：' + this.item.age)
      Text('created_at：' + this.item.created_at)
      Text('is_active：' + this.item.is_active)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .border({width:3,color:Color.Red,style:BorderStyle.Solid})
  }
}