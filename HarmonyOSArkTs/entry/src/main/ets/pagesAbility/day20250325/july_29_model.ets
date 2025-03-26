
//数据模块
@Observed
export class LemonModel{
  title: ResourceStr
  index: number
  flg?: boolean

  constructor(title: ResourceStr, index: number = 0, flg?:boolean) {
    this.title = title
    this.index = index
    this.flg = flg
  }


}

//温度区域的数据
export const temperature_Data:LemonModel[] = [
  new LemonModel('正常冰',0),
  new LemonModel('多冰',1),
  new LemonModel('少冰',2),
  new LemonModel('常温',3),
  new LemonModel('加热',4),

]
//甜度区域的数据
export const sweetness_Data:LemonModel[] = [
  new LemonModel('正常糖',0),
  new LemonModel('七分糖',1),
  new LemonModel('三分糖',2),
  new LemonModel('无糖',3),

]
//加料区域的数据
export const add_Materials: LemonModel[] = [
  new LemonModel('珍珠', 3, false),
  new LemonModel('芋圆', 2, false),
  new LemonModel('椰果', 1, false),
]