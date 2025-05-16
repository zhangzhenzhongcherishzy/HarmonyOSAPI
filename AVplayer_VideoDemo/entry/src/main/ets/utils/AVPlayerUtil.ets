import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import Logger from '../utils/Logger';

export class AVPlayerUtil{
  private surfaceId: string = '';
  private avPlayer: media.AVPlayer | undefined = undefined;
  private callBack: Function = () => {
  };

  setSurfaceId(surfaceId: string) {
    this.surfaceId = surfaceId;
  }

  setAVPlayerCallback(avPlayer: media.AVPlayer){
    //监听视频状态机变化
    avPlayer.on('stateChange',async (state:string) => {
      switch (state){
        case 'idle':
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
    //监听视频屏幕变化
    avPlayer.on('videoSizeChange', (width: number, height: number) => {
      Logger.info('屏幕变化,宽度is:' + width + ', 高度is :' + height);
      this.callBack(height / width);
    })
  }

  //初始化播放器
  async initPlayer(url: string, callBack: Function) {
    this.avPlayer = await media.createAVPlayer();
    this.callBack = callBack;
    this.setAVPlayerCallback(this.avPlayer);

    let context = getContext(this) as common.UIAbilityContext;
    let fileDescriptor = await context.resourceManager.getRawFd(url);
    let avFileDescriptor: media.AVFileDescriptor = { fd: fileDescriptor.fd, offset: fileDescriptor.offset, length: fileDescriptor.length };
    this.avPlayer.fdSrc = avFileDescriptor;
    Logger.info('fdSrc: ' + this.avPlayer.fdSrc);
  }
}