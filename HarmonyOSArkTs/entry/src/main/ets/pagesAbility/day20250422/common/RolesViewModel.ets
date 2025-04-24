export class roleItem {
  code: string;
  createTime: string;
  id: number;
  name: string;
  sort: number;
  status: number;

  constructor(code: string, createTime: string, id: number, name: string, sort: number, status: number) {
    this.code = code;
    this.createTime = createTime;
    this.id = id;
    this.name = name;
    this.sort = sort;
    this.status = status;
  }
}