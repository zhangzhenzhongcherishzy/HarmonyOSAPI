import { media } from '@kit.MediaKit';
@Entry
@Component
struct D0508Page1 {
  //1、创建一个avplayer对象
  avPlayer:media.AVPlayer | null = null
  //2、初始化
  async init(){
    //2.1、实例化播放器对象，并设置状态机
    this.avPlayer = await media.createAVPlayer()
    //2.2、使用监听
    this.avPlayer.on('stateChange',(state:media.AVPlayerState)=>{
      switch (state){
        case 'initialized':
          //如果初始化完成，立刻准备播放
          this.avPlayer?.prepare()
          console.info('initialized prepared called');
          break;
        case 'prepared':
          //准备就行，开始播放
          this.avPlayer?.play()
          console.info('state prepared called');
          break;
      }
    })
  }
  //完成初始化
  async aboutToAppear(): Promise<void> {
    await this.init()
  }
  build() {
    Column(){
      Button('播放')
        .onClick(() => {
          //1、创建一个avplayer对象
          //2、设置状态机
          //3、设置音乐源头
          const url = 'https://elaina-1017-1331423751.cos.ap-guangzhou.myqcloud.com/AVPlayer/1.mp3'
          if(this.avPlayer != null){
            this.avPlayer.url = url
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}