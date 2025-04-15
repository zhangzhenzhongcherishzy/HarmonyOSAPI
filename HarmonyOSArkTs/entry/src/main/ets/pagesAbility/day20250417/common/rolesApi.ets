import AxiosResquest from './AxiosResquestClass'

const resquest = AxiosResquest.getInstance()
resquest.isDebug = true

// /**
//  * 角色分页列表
//  * @param params
//  * @returns
//  */
// export function getRolesPage(params: IRolesPageResParams) {
//   return resquest.service<IResponse<IRolesData>, IRolesPageResParams>('/roles/page', 'get', params)
// }

class RolesApi {
  /**
   * 角色分页列表
   * @param params
   * @returns
   */
  public static getRolesPage(params: IRolesPageResParams) {
    return resquest.service<IResponse<IRolesData>, IRolesPageResParams>('/roles/page', 'get', params)
  }
  /**
   * 新增角色列表
   */
  public static  PostRoles(data:IListItem){
    return resquest.service<IResponse<IRolesData>, IRolesPageResParams,IListItem>('/roles', 'post', undefined,data)
  }
  /**
   * 修改角色列表
   */
  public static  PutRoles(id:number,data:IListItem){
    return resquest.service<IResponse<IRolesData>, IRolesPageResParams,IListItem>(`/roles/${id}`, 'put', undefined,data)
  }
  /**
   * 删除角色列表
   */
  public static  DeleteRoles(id:number){
    return resquest.service<IResponse<IRolesData>, IRolesPageResParams>(`/roles/${id}`, 'delete')
  }
}
export default RolesApi


export interface IResponse<T = Object> {
  code: string;
  data: T;
  msg: string;
}

export interface IRolesData {
  list?: IListItem[];
  pageNum: number;
  pageSize: number;
  total?: number;
}

export interface IListItem {
  id?: number;
  name: string;
  code: string;
  sort: number;
  status: number;
  dataScope: number,
  createTime?: string;
  updateTime?: string,
}


export interface IRolesRequest {
  /**
   * 角色编码
   */
  code: string;

  /**
   * 数据权限(0:全部数据,1:部门及子部门数据,2:本部门数据,3:本人数据)
   */
  dataScope: number;

  /**
   * 角色名称
   */
  name: string;

  /**
   * 排序
   */
  sort: number;

  /**
   * 角色状态(1-正常；0-停用)
   */
  status: number;

}


export interface IRolesPageResParams {
  /**
   * 结束日期
   */
  endDate?: string;

  /**
   * 关键字(角色名称/角色编码)
   */
  keywords?: string;

  /**
   * 页码
   */
  pageNum: string;

  /**
   * 每页记录数
   */
  pageSize: string;

  /**
   * 开始日期
   */
  startDate?: string;
}
