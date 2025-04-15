import { service } from './common/AxiosResquest'
import RolesApi,{ IListItem, IResponse, IRolesData,IRolesPageResParams} from './common/rolesApi'
@Entry
@Component
struct D0417Page1 {
  @State message: IListItem[] =[]

  build() {
    Scroll() {
      Column({ space: 8 }) {
        Row({ space: 15 }) {
          Button('Axios GET请求')
            .onClick(async () => {
              // let res = await getRolesPage({pageNum:'1',pageSize:'100'})
              let res = await RolesApi.getRolesPage({pageNum:'1',pageSize:'100'})
              this.message = res.data.data.list as IListItem[]
            })
          Button('Axios POST发送')
            .onClick(async () => {
              let rows: IListItem = {
                name: '小芳2',
                code: '小芳2',
                sort: 100,
                status: 1,
                dataScope: 3,
              }
              await RolesApi.PostRoles(rows)
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

        //内容渲染
        ForEach(this.message, (item: IListItem) => {
          Row({ space: 15 }) {
            Text(item.id?.toString())
              .fontSize(12)
              .padding(12)
              .border({
                width: 3,
                color: Color.Red,
                style: BorderStyle.Solid
              })
            Text(item.name.toString())
              .fontSize(12)
              .padding(12)
              .border({
                width: 3,
                color: Color.Red,
                style: BorderStyle.Solid
              })
            Button('修改')
              .onClick(async () => {
                let id: number = item.id as number
                let rows: IListItem = {
                  name: '小芳222',
                  code: '小芳222',
                  sort: 100,
                  status: 1,
                  dataScope: 3,
                }
                RolesApi.PutRoles(id,rows)
              })
            Button('删除')
              .onClick(async () => {
                let id = item.id as number
                await RolesApi.DeleteRoles(id)
              })
          }
          .width('100%')
          .padding(12)
          .justifyContent(FlexAlign.Center)
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .backgroundColor('#f1f2f3')
  }
}