
export interface ResType<T> {
  code: string;
  data: T;
  msg: string;
}

export interface PageDataType<T> {
  list: T[];
  pageNum: number;
  pageSize: number;
  total: number;
}

export interface RolesType {
  code: string;
  createTime?: string;
  id?: number;
  name: string;
  sort: number;
  status: number;
  dataScope?: number
}