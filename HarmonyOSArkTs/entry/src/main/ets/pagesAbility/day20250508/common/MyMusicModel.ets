//数据模型实体类

/*
 * 歌曲信息
 *
 * */
export interface SongItemType{
  //歌曲id
  id:string
  //歌曲链接
  url:string
  //歌曲名称
  name:string
  //歌曲作者
  author:string
  //歌曲图片
  img:ResourceStr
}

/*
 * 推荐列表
 *
 *
 * */
export interface RecommendListType{
  //图片
  img:string
  //标题
  title:string
  //人气
  count:string

}

/*
 * 每日推荐
 *
 * */
export interface RecommendDailyType{
  //图片
  img:string
  //标题
  title:string
  //类型
  type:string
  //顶部 颜色
  top:ResourceStr
  //底部 颜色
  bottom:ResourceStr

}

/*
 * 评论列表
 *
 * */
export interface MomentListType{
  //作者
  author:string
  //用户头像
  avatar:string
  //评论内容
  content:string
  //评论数量
  comment:number
  //喜爱
  like:number
  //歌曲信息
  song:SongItemType
}

/*
 * 收藏列表类型
 *
 * */
export interface FavoriteListType{
  //名称
  name:string
  //用户昵称
  nickName:string
  //头像
  avatar:ResourceStr
  //歌曲列表
  song:SongItemType[]
}


//发布的数据结构
//通知页面播放的数据结构
export interface PlayStateType{
  img:ResourceStr
  name:string
  author:string
  url:string
  playIndex:number
  //已经播放的时长
  time:number
  //播放总时间
  duration:number
  //是否正在播放
  isPlay:boolean
  //播放模式
  playMode: 'auto' | 'repeat' | 'random'
  //播放列表
  playList: SongItemType[]
}

export class PlayStateModel implements PlayStateType{
  img: ResourceStr = ''
  name: string = ''
  author: string = ''
  url: string = ''
  playIndex: number = 0
  time: number = 0
  duration: number = 0
  isPlay: boolean = false
  playMode: "auto" | "repeat" | "random" = 'auto'
  playList: SongItemType[] = null!

  //使用接口数据的引用类型，而不是使用参数值
  constructor(playState:PlayStateType) {
    this.img = playState.img
    this.name = playState.name
    this.author = playState.author
    this.url = playState.url
    this.playIndex = playState.playIndex
    this.time = playState.time
    this.duration = playState.duration
    this.isPlay = playState.isPlay
    this.playMode = playState.playMode
    this.playList = playState.playList
  }


}

export const defaultState:PlayStateType = new PlayStateModel({
  img:'',
  name:'',
  author:'',
  url:'',
  playIndex:0,
  time:0,
  duration:0,
  isPlay:false,
  playMode:'auto',
  playList:[]
})

//定义事件ID
export enum EmitEventType{
  UPDATE_STATE
}

//使用interface表示类型接口
//接口需要实现类来实现接口
//接口实现类必须覆盖重写(实现)接口中所有的抽象方法
export class SongItemTypeModel implements SongItemType{
  id: string
  url: string
  name: string
  author: string
  img: ResourceStr

  constructor(id: string, url: string, name: string, author: string, img: ResourceStr) {
    this.id = id
    this.url = url
    this.name = name
    this.author = author
    this.img = img
  }


}

export class RecommendListTypeModel implements RecommendListType{
  img: string
  title: string
  count: string

  constructor(img: string, title: string, count: string) {
    this.img = img
    this.title = title
    this.count = count
  }


}

export class RecommendDailyTypeModel implements RecommendDailyType{
  img: string
  title: string
  type: string
  top: ResourceStr
  bottom: ResourceStr

  constructor(img: string, title: string, type: string, top: ResourceStr, bottom: ResourceStr) {
    this.img = img
    this.title = title
    this.type = type
    this.top = top
    this.bottom = bottom
  }


}

export class MomentListTypeModel implements MomentListType{
  author: string
  avatar: string
  content: string
  comment: number
  like: number
  song: SongItemType

  constructor(author: string, avatar: string, content: string, comment: number, like: number, song: SongItemType) {
    this.author = author
    this.avatar = avatar
    this.content = content
    this.comment = comment
    this.like = like
    this.song = song
  }


}

export class FavoriteListTypeModel implements FavoriteListType{
  name: string
  nickName: string
  avatar: ResourceStr
  song: SongItemType[]

  constructor(name: string, nickName: string, avatar: ResourceStr, song: SongItemType[]) {
    this.name = name
    this.nickName = nickName
    this.avatar = avatar
    this.song = song
  }


}
