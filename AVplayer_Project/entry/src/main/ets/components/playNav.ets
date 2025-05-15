import { PlayStateType} from '../models/Index'
@Preview
@Component
export default struct playNav {
  //接受来自于播放的歌曲信息
  @Link playState:PlayStateType
  build() {
    Row(){
      //歌曲信息
      Row({space:10}){
        Image(this.playState.img)
          .width(40)
        //文字、音乐名称，作者
        Column(){
          Text(this.playState.name)
            .maxLines(1)
            .textOverflow({overflow:TextOverflow.Ellipsis})
            .fontColor('#fff')
          Text(this.playState.author)
            .fontSize(12)
            .fontColor('#ccc')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)
      //播放控件
      Row({space:16}){
        //上一曲
        Image($r('app.media.ic_prev'))
          .width(20)
          .fillColor('#4cafc6')
        //暂停/播放
        Image(this.playState.isPlay ? $r('app.media.ic_paused') : $r('app.media.ic_play') )
          .width(20)
          .fillColor('#4cafc6')
        //下一曲
        Image($r('app.media.ic_next'))
          .width(20)
          .fillColor('#4cafc6')
      }
      .width(98)
      .height('100%')
    }
    .width('100%')
    .height(60)
    .backgroundColor('#cc5b5b86')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({left:20,right:20})
  }
}