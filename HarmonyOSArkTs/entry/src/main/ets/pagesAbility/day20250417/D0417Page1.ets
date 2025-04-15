import { service } from './common/AxiosResquest'
import { IListItem, IResponse, IRolesData,IRolesPageResParams} from './common/rolesApi'
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
              let res = await service<IResponse<IRolesData>, IRolesPageResParams,IListItem>('/roles/page', 'get', {
                pageNum:'1',
                pageSize: '100'
              })
              this.message = res.data.data.list as IListItem[]
            })
          Button('Axios POST发送')
            .onClick(async () => {
              let rows: IListItem = {
                name: '小芳1',
                code: '小芳1',
                sort: 100,
                status: 1,
                dataScope: 3,
              }
              service<IResponse<IRolesData>, IRolesPageResParams,IListItem>('/roles', 'post',undefined,rows)
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
              .onClick(() => {
                let id: number = item.id as number
                let rows: IListItem = {
                  name: '小芳111',
                  code: '小芳111',
                  sort: 100,
                  status: 1,
                  dataScope: 3,
                }
                service<IResponse<IRolesData>, IRolesPageResParams,IListItem>(`/roles/${id}`, 'put',undefined,rows)
              })
            Button('删除')
              .onClick(() => {
                let id = item.id as number
                service<IResponse<IRolesData>, IRolesPageResParams,IListItem>(`/roles/${id}`, 'delete')
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