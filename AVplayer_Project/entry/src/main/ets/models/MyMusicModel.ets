/**
 * 发布得数据解构  通知页面播放得数据结构
 */
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
  playList:SongItemType[]
}
/**
 * 歌曲信息
 */
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
  img:string
}
/**
 * 推荐列表
 */
export interface RecommendListType{
  //图片
  img:string
  //标题
  title:string
  //人气
  count:string
}
/**
 * 每日推荐
 */
export interface RecommendDailyType{
  //图片
  img:string
  //标题
  title:string
  //类型
  type:string
  //顶部 颜色
  top:string
  //底部 颜色
  bottom:string
}
/**
 * 评论列表
 */
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
/**
 * 收藏列表类型
 */
export interface FavoriteListType{
  //名称
  name:string
  //用户名称
  nickName:string
  //头像
  avatar:ResourceStr
  //歌曲列表
  songs:SongItemType[]
}

//播放的歌曲信息类
export class PlayStateModel implements PlayStateType{
  img:ResourceStr = ''
  name: string =''
  author: string = ''
  url: string =''
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
//类的初始化
export const defaultState:PlayStateType = new PlayStateModel({
  img:"",
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

//歌曲信息类
export class SongItemTypeModel implements  SongItemType{
  id:string
  url: string
  name: string
  author: string
  img: string
  constructor(id:string,url:string,name:string,author:string,img:string) {
    this.id = id
    this.url = url
    this.name = name
    this.author = author
    this.img = img
  }
}
//推荐列表类
export class RecommentListTypeModel implements RecommendListType {
  img: string
  title: string
  count: string
  constructor(img:string,title:string,count:string) {
    this.img = img
    this.title = title
    this.count = count
  }
}
//每日推荐类
export class RecommendDailyTypeModel implements RecommendDailyType{
  img: string
  title: string
  type: string
  top: string
  bottom: string
  constructor(img: string, title: string, type: string, top: string, bottom: string) {
    this.img = img
    this.title = title
    this.type = type
    this.top = top
    this.bottom = bottom
  }
}
//评论列表类
export class  MomentListTypeModel implements MomentListType{
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
//收藏列表类
export class FavoriteListTypeModel implements FavoriteListType{
  name: string
  nickName: string
  avatar: ResourceStr
  songs: SongItemType[]
  constructor(name: string, nickName: string, avatar: ResourceStr, songs: SongItemType[]) {
    this.name = name
    this.nickName = nickName
    this.avatar = avatar
    this.songs = songs
  }
}
