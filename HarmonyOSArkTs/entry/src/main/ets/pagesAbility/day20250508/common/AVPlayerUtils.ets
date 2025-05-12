import { media } from '@kit.MediaKit';

/**
 * 音乐播放公共模块
 */
export class AVPlayerUtils {
  //设置静态属性变量，作为AVPlayer对象的承接者
  static avPlayer: media.AVPlayer | null = null
  //歌曲总时长
  static duration: number = 0
  //歌曲当前的播放时长
  static time: number = 0
  //歌曲是否正在播放
  static isPlay: boolean = false

  //实例化播放器对象 初始化
  static async init() {
    AVPlayerUtils.avPlayer = await media.createAVPlayer()
    AVPlayerUtils.avPlayer.on('stateChange', (state: media.AVPlayerState) => {
      switch (state) {
        case 'initialized':
          AVPlayerUtils.avPlayer?.prepare()
          console.info('initialized prepared called');
          break;
        case 'prepared':
          AVPlayerUtils.avPlayer?.play()
          console.info('state prepared called');
          break;
        case 'playing':
          console.log(`当前处于playing`)
          AVPlayerUtils.isPlay = true
          break
        case 'paused':
          console.log(`当前处于paused`)
          // AVPlayerUtils.isPlay = false
          break
        case 'completed':
          console.log(`当前处于completed`)
          // AVPlayerUtils.isPlay = false
          // AVPlayerUtils.next()
          break
      }
    })

    //监听歌曲总时长
    AVPlayerUtils.avPlayer.on('durationUpdate', (duration) => {
      AVPlayerUtils.duration = duration
      console.log(`当前歌曲总时长为:${duration}`)
    })
    //监听歌曲播放的当前时长
    AVPlayerUtils.avPlayer.on('timeUpdate', (time) => {
      AVPlayerUtils.time = time
      console.log(`当前歌曲播放时长为:${time}`)
    })
  }

  //单曲播放功能
  static async playSingle(url: string) {
    await AVPlayerUtils.init()
    if (AVPlayerUtils.avPlayer != null) {
      //将音频资源路径赋值给avPlayer，使其
      //状态机由idle 变为 initialized 触发状态机的监听
      AVPlayerUtils.avPlayer.url = url
    }
  }

  //暂停功能
  static pause() {
    AVPlayerUtils.avPlayer?.pause()
  }

  //恢复播放
  static play() {
    AVPlayerUtils.avPlayer?.play()
  }

  //停止播放
  static stop() {
    if (AVPlayerUtils.avPlayer?.state == 'playing' || AVPlayerUtils.avPlayer?.state == 'paused' ||
      AVPlayerUtils.avPlayer?.state == 'completed' || AVPlayerUtils.avPlayer?.state == 'prepared') {
      AVPlayerUtils.avPlayer?.stop()
    }
  }
}