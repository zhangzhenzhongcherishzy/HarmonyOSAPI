import { media } from "@kit.MediaKit";
import { songs } from "../constants/MusicConstants";
import { EmitEventType, PlayStateType, SongItemType } from "../models/MyMusicModel";
import { emitter } from "@kit.BasicServicesKit";

export class AVPlayerUtils {
  //设置静态属性变量，作为AVPlayer对象的承接者
  static avPlayer: media.AVPlayer | null = null
  //视频时长
  static duration: number = 0
  //视频的当前播放时长
  static time: number = 0
  //视频是否正在播放
  static isPlay: boolean = false
  //当前的播放模式
  static playMode: 'auto' | 'repeat' | 'random' = 'auto'
  //当前的播放列表
  static playList: SongItemType[] = songs
  //播放的索引
  static playIndex: number = -1
  //获取视频id
  static surfaceId: string = '';
  //计算视频比例的回调函数
  static callBack: Function = () => {
  };

  //初始化
  static async init() {
    //创建AVPlayer对象，此方法为Promise方法
    AVPlayerUtils.avPlayer = await media.createAVPlayer()
    //AVPlayer播放的原理就是通过某些方法改变状态机
    AVPlayerUtils.avPlayer.on('stateChange', (state: media.AVPlayerState) => {
      switch (state) {
        case 'idle':
          console.log(`当前处于：${state}`)
          AVPlayerUtils.isPlay = false
          break
        case 'initialized':
          console.log(`当前处于：${state}`)
          if (AVPlayerUtils.avPlayer != undefined) {
            AVPlayerUtils.avPlayer.surfaceId = AVPlayerUtils.surfaceId;
            console.log("赋值id是否生效：" + AVPlayerUtils.avPlayer.surfaceId)
          }
          AVPlayerUtils.avPlayer?.prepare()
          break
        case 'prepared':
          console.log(`当前处于：${state}`)
          AVPlayerUtils.avPlayer?.play()
          //1倍速播放
          AVPlayerUtils.videoSpeed1()
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
    //监听视频时长
    AVPlayerUtils.avPlayer.on('durationUpdate', (duration) => {
      AVPlayerUtils.duration = duration
    })
    //监听视频当前已经播放的进度 特点：每时每刻都在触发
    AVPlayerUtils.avPlayer.on('timeUpdate', (time) => {
      AVPlayerUtils.time = time
      const PlayState: PlayStateType = {
        img: AVPlayerUtils.playList[AVPlayerUtils.playIndex].img,
        name: AVPlayerUtils.playList[AVPlayerUtils.playIndex].name,
        author: AVPlayerUtils.playList[AVPlayerUtils.playIndex].author,
        url: AVPlayerUtils.playList[AVPlayerUtils.playIndex].url,
        playIndex: AVPlayerUtils.playIndex,
        time: AVPlayerUtils.time,
        duration: AVPlayerUtils.duration,
        isPlay: AVPlayerUtils.isPlay,
        playMode: AVPlayerUtils.playMode,
        playList: AVPlayerUtils.playList,
      }
      //将准备好的数据送出去
      AVPlayerUtils.updataState(PlayState)
    })
    //监听视频播放宽高变化事件
    AVPlayerUtils.avPlayer.on('videoSizeChange', (width: number, height: number) => {
      AVPlayerUtils.callBack(height / width) // 得到的结果 视频高和宽比例
    })
  }

  //封装方法：获取视频id
  static setSurfaceId(surfaceId: string) {
    AVPlayerUtils.surfaceId = surfaceId;
    console.log('设置id是否生效：' + AVPlayerUtils.surfaceId)
    AVPlayerUtils.PlayVideo()
  }

  //切换AVPlayerUtils.surfaceId
  static async ChangeplayIndex(value: SongItemType) {
    AVPlayerUtils.playIndex = songs.findIndex(index => index.name == value.name)
    console.log('跳转设置播放索引是否成功：' + AVPlayerUtils.playIndex)
  }

  //播放功能代码
  static async PlayVideo() {
    //重置状态机为闲置 通过reset方法重置播放器状态
    await AVPlayerUtils.avPlayer?.reset()
    //重置当前进度为0
    AVPlayerUtils.time = 0
    //切换url
    if (AVPlayerUtils.avPlayer != null) {
      //更新播放状态
      AVPlayerUtils.isPlay = true
      AVPlayerUtils.avPlayer.url = AVPlayerUtils.playList[AVPlayerUtils.playIndex].url
    }
    //1倍速播放
    AVPlayerUtils.videoSpeed1()
  }

  //更新播放信息到各个页面
  static updataState(playstate: PlayStateType) {
    emitter.emit({
      eventId: EmitEventType.UPDATE_STATE
    }, {
      data: {
        playState: JSON.stringify(playstate)
      }
    })
  }

  //暂停播放
  static pause() {
    AVPlayerUtils.avPlayer?.pause()
    AVPlayerUtils.isPlay = false
  }

  //恢复播放
  static play() {
    AVPlayerUtils.avPlayer?.play()
    AVPlayerUtils.isPlay = true
  }

  //拖动播放
  static seek(time: number) {
    AVPlayerUtils.avPlayer?.seek(time)
    //更新播放状态
    AVPlayerUtils.play()
  }

  //上一首
  static prev() {
    AVPlayerUtils.playIndex--
    //如果超过播放列表
    AVPlayerUtils.playIndex = (AVPlayerUtils.playIndex + AVPlayerUtils.playList.length) % AVPlayerUtils.playList.length
    AVPlayerUtils.PlayVideo()
  }

  //下一首
  static next() {
    AVPlayerUtils.playIndex++
    //如果超过播放列表
    AVPlayerUtils.playIndex = (AVPlayerUtils.playIndex + AVPlayerUtils.playList.length) % AVPlayerUtils.playList.length
    AVPlayerUtils.PlayVideo()
  }
  //0.5倍速播放
  static videoSpeed05(): void {
    if (AVPlayerUtils.avPlayer) {
      try {
        AVPlayerUtils.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_0_50_X);
        console.info('videoSpeed 0.5');
      } catch (e) {
        console.info('videoSpeed 0.5' + `${JSON.stringify(e)}`);
      }
    }
  }
  //1倍速播放
  static videoSpeed1(): void {
    if (AVPlayerUtils.avPlayer) {
      try {
        AVPlayerUtils.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_00_X);
        console.info('videoSpeed 1');
      } catch (e) {
        console.info('videoSpeed 1' + `${JSON.stringify(e)}`);
      }
    }
  }
  //1.5倍速播放
  static videoSpeed15(): void {
    if (AVPlayerUtils.avPlayer) {
      try {
        AVPlayerUtils.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_50_X);
        console.info('videoSpeed 1.5');
      } catch (e) {
        console.info('videoSpeed 1.5' + `${JSON.stringify(e)}`);
      }
    }
  }
  //2倍速播放
  static videoSpeed2(): void {
    if (AVPlayerUtils.avPlayer) {
      try {
        AVPlayerUtils.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_2_00_X);
        console.info('videoSpeed 2');
      } catch (e) {
        console.info('videoSpeed 2' + `${JSON.stringify(e)}`);
      }
    }
  }
  //销毁播放器
  static async relase() {
    await AVPlayerUtils.avPlayer?.release()
  }
}