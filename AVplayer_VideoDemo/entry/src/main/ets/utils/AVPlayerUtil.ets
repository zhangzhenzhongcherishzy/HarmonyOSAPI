import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import Logger from './Logger';
/**
 * 视频播放器工具类
 */
export class AVPlayerUtil {
  //获取视频id
  private surfaceId: string = '';
  //用于承接视频播放器实例
  private  avPlayer: media.AVPlayer | undefined = undefined;
  //计算视频比例的回调函数
  private callBack: Function = () => {
  };

  //封装方法：获取视频id 并赋值给类中的this.surfaceId
  setSurfaceId(surfaceId: string) {
    this.surfaceId = surfaceId;
  }

  //设置播放器的回调时机
  setAVPlayerCallback(avPlayer: media.AVPlayer) {
    //监听播放状态
    avPlayer.on('stateChange', async (state: string) => {
      switch (state) {
        case 'idle': //闲置状态
          Logger.info(`当前处于：${state}`);
          avPlayer.release();
          break;
        case 'initialized':
          Logger.info(`当前处于：${state}`);
          avPlayer.surfaceId = this.surfaceId;
          avPlayer.prepare();
          break;
        case 'prepared':
          Logger.info(`当前处于：${state}`);
          avPlayer.play();
          break;
        case 'playing':
          Logger.info(`当前处于：${state}`);
          break;
        case 'paused':
          Logger.info(`当前处于：${state}`);
          break;
        case 'completed':
          Logger.info(`当前处于：${state}`);
          avPlayer.play();
          break;
        case 'stopped':
          Logger.info(`当前处于：${state}`);
          avPlayer.reset();
          break;
        case 'released':
          Logger.info(`当前处于：${state}`);
          break;
        default:
          break;
      }
    })
    //监听视频播放宽高变化事件
    avPlayer.on('videoSizeChange', (width: number, height: number) => {
      Logger.info('视频播放宽高,宽度是:' + width + ', 高度是 :' + height);
      this.callBack(height / width) // 得到的结果 视频高和宽比例
    })
  }

  //初始化播放器  url: string 代表视频真实的路径（网络/本地）  callBack：视频宽高比例回调
  async initPlayer(url: string, callBack: Function) {
    //创建avplayer 播放器实例
    this.avPlayer = await media.createAVPlayer()
    //拿到视频的宽高比例
    this.callBack = callBack
    //调用视频尺寸变化时，高和宽的比例
    this.setAVPlayerCallback(this.avPlayer)

    //准备资源 读取本地媒体的资源文件
    let context = getContext(this) as common.UIAbilityContext
    let fileDescriptor = await context.resourceManager.getRawFd(url)
    // 进行赋值
    let avFileDescriptor:media.AVFileDescriptor = {fd:fileDescriptor.fd,offset:fileDescriptor.offset,length:fileDescriptor.length}
    this.avPlayer.fdSrc = avFileDescriptor
  }
}