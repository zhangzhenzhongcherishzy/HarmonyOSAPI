import { MineData } from './Class'
class itemdata {
  //列表区数据
  getminelist(): Array<MineData> {
    let minelist: Array<MineData> = [
      new MineData($r('app.media.news'), '推送通知', '厦门站我们不见不散'),
      new MineData($r('app.media.data'), '数据管理'),
      new MineData($r('app.media.menu'), '菜单设置'),
      new MineData($r('app.media.about'), '关于'),
      new MineData($r('app.media.storage'), '清除缓存'),
      new MineData($r('app.media.privacy'), '隐私协议')
    ]
    return minelist
  }
}
export default new itemdata()