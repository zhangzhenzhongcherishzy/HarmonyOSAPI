import { avSession } from "@kit.AVSessionKit";
import backgroundTaskManager from "@ohos.resourceschedule.backgroundTaskManager";
import { wantAgent } from "@kit.AbilityKit";
import { SongItemType } from "../models/Index";
import { AVPlayerUtils } from "./AVPlayerUtils";

export class AVSessionUtils {
  //设置静态属性变量，作为AVSession对象的承接者
  static AVSession: avSession.AVSession | null = null

  //1、AVSession创建实例对象，实现初始化
  static async init(content: Context) {
    AVSessionUtils.AVSession = await avSession.createAVSession(content, 'MusciPlay', 'audio')
    //初始化后进行命令激活
    AVSessionUtils.registerAVSession()
  }

  //2、Background Tasks Kit创建后台任务
  static async startBackgroundRunning() {
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      // 点击通知后，将要执行的动作列表 ,添加需要被拉起应用的bundleName和abilityName
      wants: [
        {
          bundleName: "com.example.harmonyos_avplayermusic",
          abilityName: "EntryAbility"
        }
      ],
      // 指定点击通知栏消息后的动作是拉起ability
      actionType: wantAgent.OperationType.START_ABILITY,
      // 使用者自定义的一个私有值
      requestCode: 0,
      // 点击通知后，动作执行属性
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG],
    };
    await backgroundTaskManager.startBackgroundRunning(getContext(), ['AUDIO_PLAYBACK'],
      wantAgent.getWantAgent(wantAgentInfo))
  }

  //3、AVSession设置元数据 设置必要的媒体信息
  static setAVMetadata(song: SongItemType) {
    AVSessionUtils.AVSession?.setAVMetadata({
      assetId: song.id,
      title: song.name,
      artist: song.author,
      author: song.author,
      writer: '小明',
      composer: '小红',
      duration: AVPlayerUtils.duration,
      //歌词
      lyric:AVPlayerUtils.lyric
    })
  }
  //4、AVSession设置播放状态
  static setAVPlaybackState(){
    AVSessionUtils.AVSession?.setAVPlaybackState({
      //同步播放的状态
      state:AVPlayerUtils.isPlay ? avSession.PlaybackState.PLAYBACK_STATE_PLAY : avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
      //同步播放速度
      speed:1,
      //同步播放位置
      position:{
        elapsedTime:AVPlayerUtils.time,//播放时间
        updateTime:new Date().getTime() //更新时间
      },
      duration:AVPlayerUtils.duration,
      loopMode:AVPlayerUtils.playMode == 'auto' ? avSession.LoopMode.LOOP_MODE_SEQUENCE : AVPlayerUtils.playMode == 'random' ? avSession.LoopMode.LOOP_MODE_SHUFFLE : avSession.LoopMode.LOOP_MODE_SINGLE,
    })
  }
  //5、AVSession注册控制命令
  static registerAVSession(){
    //播放
    AVSessionUtils.AVSession?.on('play',() =>{
      AVPlayerUtils.SingPlayPlus(AVPlayerUtils.playList[AVPlayerUtils.playIndex])
    })
    //暂停
    AVSessionUtils.AVSession?.on('pause',() => {
      AVPlayerUtils.pause()
    })
    //上一首
    AVSessionUtils.AVSession?.on('playPrevious',() => {
      AVPlayerUtils.prev()
    })
    //下一首
    AVSessionUtils.AVSession?.on('playNext',() => {
      AVPlayerUtils.next()
    })
    //循环模式
    // AVSessionUtils.AVSession?.on('setLoopMode',(mode:avSession.LoopMode) => {
    //   mode ==  avSession.LoopMode.LOOP_MODE_SEQUENCE ? AVPlayerUtils.changeMode('auto') : mode ==  avSession.LoopMode.LOOP_MODE_SINGLE ? AVPlayerUtils.changeMode('repeat') :AVPlayerUtils.changeMode('random')
    // })
    //进度条
    AVSessionUtils.AVSession?.on('seek',(time:number)=>{
      AVPlayerUtils.time  = time
      AVPlayerUtils.avPlayer?.seek(time)
    })
    //激活控制命令
    AVSessionUtils.AVSession?.activate()
  }
  //6、AVSession注册会话
  static async destroy(){
    await AVSessionUtils.AVSession?.destroy()
  }
}