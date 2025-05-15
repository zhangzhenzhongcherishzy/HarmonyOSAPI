import { media } from "@kit.MediaKit";
import { EmitEventType, PlayStateType, SongItemType } from "../models/Index";
import { emitter } from "@kit.BasicServicesKit";
import { AVSessionUtils } from "./AVSessionUtils";

/**
 * 音乐播放公共模块
 */
export class AVPlayerUtils {
  //设置静态属性变量，作为AVPlayer对象的承接者
  static avPlayer:media.AVPlayer | null = null
  /**
   * 获取歌曲信息
   * 歌曲信息中包含歌曲时长，断点续播需要知道播放的进度，所以需要记录两条信息
   *
   * 歌曲时长
   * 当前的播放时长
   * 是否播放
   * 获取播放模式
   */
  //歌曲时长
  static duration:number = 0
  //歌曲的当前播放时长
  static time:number = 0
  //歌曲是否正在播放
  static isPlay:boolean = false
  //当前的播放模式
  static playMode:'auto' | 'repeat' | 'random' = 'auto'
  //当前的播放列表
  static playList:SongItemType[] = []
  //播放的索引
  static playIndex:number = -1
  /**
   * 1、初始化
   * 我们需要在整个应用进入环境时，就进行播放去的创建，所以我们在EntryAbility的onWindowStageCreate周期中进行调用
   * 此时我们已经完成了播放器的创建，播放状态为idle（闲置）
   */
  static async init(){
    //创建AVPlayer对象，此方法为Promise方法
    AVPlayerUtils.avPlayer = await media.createAVPlayer()
    //AVPlayer播放的原理就是通过某些方法改变状态机
    AVPlayerUtils.avPlayer.on('stateChange',(state:media.AVPlayerState) => {
      switch (state){
        case 'idle':
          console.log(`当前处于：${state}`)
          AVPlayerUtils.isPlay = false
          break
        case 'initialized':
          console.log(`当前处于：${state}`)
          AVPlayerUtils.avPlayer?.prepare()
          break
        case 'prepared':
          console.log(`当前处于：${state}`)
          AVPlayerUtils.avPlayer?.play()
          break
        case 'playing':
          console.log(`当前处于：${state}`)
          AVPlayerUtils.isPlay = true
          break
        case 'paused':
          console.log(`当前处于：${state}`)
          AVPlayerUtils.isPlay = false
          break
        case 'completed':
          console.log(`当前处于：${state}`)
          AVPlayerUtils.isPlay = false
          AVPlayerUtils.next()
          break
        case 'released':
          console.log(`当前处于：${state}`)
          AVPlayerUtils.avPlayer?.release()
          break
      }
    })
    //监听歌曲时长
    AVPlayerUtils.avPlayer.on('durationUpdate',(duration) => {
      AVPlayerUtils.duration = duration
      //同步歌曲信息到控制中心
      AVSessionUtils.setAVMetadata(AVPlayerUtils.playList[AVPlayerUtils.playIndex])
      console.log(`当前歌曲总时长为：${duration}`)
    })
    //监听歌曲当前已经播放的进度 特点：每时每刻都在触发
    AVPlayerUtils.avPlayer.on('timeUpdate',(time) => {
      AVPlayerUtils.time = time
      //同步播放状态到控制中心
      AVSessionUtils.setAVPlaybackState()
      console.log(`当前已经播放的进度为：${time}`)
      //这里在歌曲播放时会不断的执行，不断的发送播放状态
      const PlayState:PlayStateType = {
          img : AVPlayerUtils.playList[AVPlayerUtils.playIndex].img,
          name : AVPlayerUtils.playList[AVPlayerUtils.playIndex].name,
          author:  AVPlayerUtils.playList[AVPlayerUtils.playIndex].author,
          url:  AVPlayerUtils.playList[AVPlayerUtils.playIndex].url,
          playIndex: AVPlayerUtils.playIndex,
          time:  AVPlayerUtils.time,
          duration:  AVPlayerUtils.duration,
          isPlay: AVPlayerUtils.isPlay,
          playMode: AVPlayerUtils.playMode,
          playList: AVPlayerUtils.playList,
      }
      //将准备好的数据发送出去
      AVPlayerUtils.updataState(PlayState)
    })
  }
  //添加多首歌曲，切歌功能   重置、切歌曲，通过url切换歌曲，只有位于闲置状态才能切换url
  static async ChangePlay(){
    //重置状态机为闲置 通过reset方法重置播放器状态
    await AVPlayerUtils.avPlayer?.reset()
    //重置当前进度为0
    AVPlayerUtils.time = 0
    //切换url
    if(AVPlayerUtils.avPlayer !== null){
      AVPlayerUtils.avPlayer.url = AVPlayerUtils.playList[AVPlayerUtils.playIndex].url
      console.log(AVPlayerUtils.avPlayer.url);
    }
  }
  //播放功能代码
  static async SingPlayPlus(songs:SongItemType){
    //播放音乐时进行后台任务申请
    AVSessionUtils.startBackgroundRunning()
    //同步播放状态到控制中心
    AVSessionUtils.setAVPlaybackState()
    //首先判断歌曲播放列表中是否存在该歌曲，如果存在，再判断是否正在播放，如果正在播放，重头播放，如果不在播放，则切歌,如果没有在列表中，则添加进列表后进行切歌
    //判断是否在列表中
    const  isList = AVPlayerUtils.playList.some(item => item.id  === songs.id)
    //如果存在于列表中
    if(isList){
      //如果点击的歌曲为当前正在播放的歌曲
      if(AVPlayerUtils.avPlayer?.url == songs.url){
        AVPlayerUtils.play()
      }else {
        //查找这首的index
        AVPlayerUtils.playIndex = AVPlayerUtils.playList.findIndex((item:SongItemType) => item.id === songs.id)
        AVPlayerUtils.ChangePlay()
      }
    }else {
      //在播放之前需要做一些操作，让点击的歌曲添加至播放列表，更换播放序号
      AVPlayerUtils.playList.unshift(songs)
      //当点击新的歌曲后，该歌曲必然回来到数组的第0个，故将播放索引变为0指向当前添加的新歌曲
      AVPlayerUtils.playIndex = 0
      AVPlayerUtils.ChangePlay()
    }
    console.log(`此时歌曲列表信息:${JSON.stringify(AVPlayerUtils.playList)}`)
  }
  //更新播放信息到各个页面
  /*
   * 目前我们已经记录了页面需要的播放信息，歌曲也能够正常添加与播放，但是各个
   * 页面还有更新(声画不同步)，所以我们需要将信息同步到页面
   * 信息的来源在工具类文件里面，需要同步的对象是UI界面
   * 这个属于工具类到page的通讯，需要使用到线程通信
   * 线程通信常用的两种:
   *  Emitter 和 Worker
   * Emitter适用于线程间发送和处理事件的能力(发布和订阅)
   * Worker适用于与主线程并行的独立线程(并行计算)
   * 此处更适合使用Emitter进行通信，从而将播放信息传递至各个页面
   * 发布者是播放器,订阅者就是需要用到信息的各个页面
   * */
  static updataState(playstate:PlayStateType){
    /**
     * eventID 发送的事件ID,长度不超过10240字节的自定义字符串，且不可以为空字符
     * data 事件携带的数据
     */
    emitter.emit({
      eventId:EmitEventType.UPDATE_STATE
    },{
      data:{
        /**
         * 会出现一个bug 发送的数据如果多层嵌套会出现丢失，所以我们推荐使用统一的字符串方式传递
         */
        //构造字符串
        playState:JSON.stringify(playstate)
      }
    })
    console.log('广播开始')
  }
  //暂停播放
  static pause(){
    AVPlayerUtils.avPlayer?.pause()
    //同步播放状态到控制中心
    AVSessionUtils.setAVPlaybackState()
    AVPlayerUtils.isPlay = false
  }
  //恢复播放
  static play(){
    AVPlayerUtils.avPlayer?.play()
    //同步播放状态到控制中心
    AVSessionUtils.setAVPlaybackState()
    AVPlayerUtils.isPlay = true
  }
  //上一首
  static prev(){
    if(AVPlayerUtils.playList.length == 0){
      return
    }
    //随机模式
    if(AVPlayerUtils.playMode == 'random' && AVPlayerUtils.playList.length > 1){
      let index = 0
      do{
        index = Math.floor(Math.random() * AVPlayerUtils.playList.length)
        //如果取随机值 取到了正在播放的歌曲
      }while (index === AVPlayerUtils.playIndex){
        //取随机值完毕后，将取到的值赋值给playIndex
        AVPlayerUtils.playIndex = index
      }
    }else  if(AVPlayerUtils.playMode == 'auto' && AVPlayerUtils.playList.length > 1){
      AVPlayerUtils.playIndex --
      //如果超过播放列表
      AVPlayerUtils.playIndex = (AVPlayerUtils.playIndex  + AVPlayerUtils.playList.length ) % AVPlayerUtils.playList.length
    }else {
      AVPlayerUtils.SingPlayPlus(AVPlayerUtils.playList[AVPlayerUtils.playIndex])
    }
    AVPlayerUtils.ChangePlay()
  }
  //下一首
  static next(){
    if(AVPlayerUtils.playList.length == 0){
      return
    }
    //随机模式
    if(AVPlayerUtils.playMode == 'random' && AVPlayerUtils.playList.length > 1){
      let index = 0
      do{
        index = Math.floor(Math.random() * AVPlayerUtils.playList.length)
        //如果取随机值 取到了正在播放的歌曲
      }while (index === AVPlayerUtils.playIndex){
        //取随机值完毕后，将取到的值赋值给playIndex
        AVPlayerUtils.playIndex = index
      }
    }else  if(AVPlayerUtils.playMode == 'auto' && AVPlayerUtils.playList.length > 1){
      AVPlayerUtils.playIndex ++
      //如果超过播放列表
      AVPlayerUtils.playIndex = (AVPlayerUtils.playIndex  + AVPlayerUtils.playList.length ) % AVPlayerUtils.playList.length
    }else {
      AVPlayerUtils.SingPlayPlus(AVPlayerUtils.playList[AVPlayerUtils.playIndex])
    }
    AVPlayerUtils.ChangePlay()
  }
  //切换播放模式
  static changeMode(mode:'auto' | 'repeat' | 'random'){
    AVPlayerUtils.playMode = mode
    //同步播放状态到控制中心
    AVSessionUtils.setAVPlaybackState()
    //切换模式之后，发送一遍数据  因为如果处于暂停状态，则播放进度的订阅不会发送，则需要在此处发送
    const PlayState:PlayStateType = {
      img : AVPlayerUtils.playList[AVPlayerUtils.playIndex].img,
      name : AVPlayerUtils.playList[AVPlayerUtils.playIndex].name,
      author:  AVPlayerUtils.playList[AVPlayerUtils.playIndex].author,
      url:  AVPlayerUtils.playList[AVPlayerUtils.playIndex].url,
      playIndex: AVPlayerUtils.playIndex,
      time:  AVPlayerUtils.time,
      duration:  AVPlayerUtils.duration,
      isPlay: AVPlayerUtils.isPlay,
      playMode: AVPlayerUtils.playMode,
      playList: AVPlayerUtils.playList,
    }
    //将准备好的数据发送出去
    AVPlayerUtils.updataState(PlayState)
  }
  //销毁播放器
  static  async relase(){
    await AVPlayerUtils.avPlayer?.release()
  }
}