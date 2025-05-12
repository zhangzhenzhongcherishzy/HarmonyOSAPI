import { favoriteList } from "../constants/MusicConstants"
import { SongItemType } from "../models/MyMusicModel"

@Entry
@Component
export struct SongListPage {
  /**
   * 封装分享 、 评论 、 收藏按钮
   */
  @Builder
  getButton(img:ResourceStr,text:string){
    Button(){
      Row({space:8}){
        Image(img)
          .width(20)
          .fillColor('#ec5c87')
        Text(text)
          .fontColor(Color.White)
          .fontSize(12)
      }
      .width('100')
      .height(36)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#ff353333')
    }
    .clip(true)
  }
  //歌单明细 显示个人的图片 标题 昵称 还有按钮
  @Builder
  musicLike(){
    Column(){
      //简介部分
      Row({space:8}){
        Row(){
          //左边的图片
          Image(favoriteList.avatar)
            .width('80%')
            .opacity(0.8)
            .fillColor('#ff5186')
        }
        .width(100)
        .aspectRatio(1)
        .borderRadius(8)
        .backgroundColor('#ffecdfdf')
        .justifyContent(FlexAlign.Center)
        //有点文字
        Column({space:12}){
          Text(favoriteList.name)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Text(favoriteList.nickName)
            .fontSize(12)
            .fontColor('#ffa49a9a')
          Blank()
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      //按钮部分
      Row(){
        this.getButton($r('app.media.ic_share'),'分享')
        this.getButton($r('app.media.ic_comment'),'评论')
        this.getButton($r('app.media.ic_collect'),'收藏')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height('30%')
    .justifyContent(FlexAlign.SpaceAround)
    .padding(16)
    .radialGradient({
      center:['80%','0%'],
      radius:'100%',
      colors:[['#ffb619ef',0.0], [Color.Transparent,1.0]]
    })
  }
  //播放列表
  @Builder
  musicList(){
    Column(){
      //播放全部
      Row({space:8}){
        Row({space:8}){
          //播放图标
          Image($r('app.media.ic_play'))
            .width(16)
            .fillColor('#ff5186')
          //播放全部文字
          Text(`播放全部(${favoriteList.songs.length})`)
            .fontColor(Color.White)
            .fontSize(14)
        }
      }
      .width('100%')
      .padding(16)
      .border({width:1,color:'#12ec5c87'})
      //歌曲列表
      Column(){
        List(){
          ForEach(favoriteList.songs,(item:SongItemType,index)=>{
            ListItem(){
              Row(){
                Row(){
                  if(index ==0){
                    Text((index + 1 ).toString())
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#ffe426')
                  }else if(index == 1){
                    Text((index + 1 ).toString())
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.primary_light'))
                  }else if(index == 2){
                    Text((index + 1 ).toString())
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.primary_dark'))
                  }else {
                    Text((index + 1 ).toString())
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#ffa49a9a')
                  }
                }
                .width(50)
                .aspectRatio(1)
                .justifyContent(FlexAlign.Center)
                //列表
                Row({space:10}){
                  if(index < 3){
                    Image(item.img)
                      .width(32)
                      .aspectRatio(1)
                      .borderRadius(4)
                  }
                  Column(){
                    Text(item.name)
                      .fontSize(14)
                      .fontColor('#ffa49a9a')
                    Text(item.author)
                      .fontSize(12)
                      .fontColor(Color.Gray)
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)
                  .justifyContent(FlexAlign.Center)
                }.layoutWeight(1)
                Image($r('app.media.ic_more'))
                  .width(24)
                  .margin({right:16})
                  .fillColor(Color.Gray)
              }
              .alignItems(VerticalAlign.Center)
            }
            .border({width:1,color:'#12ec5c87'})
            .onClick(() => {
              //点击执行 传递歌曲数据到播放页
              console.log(JSON.stringify(item))
            })
          },(item:SongItemType,index) => JSON.stringify(item))
          //触底显示底线
          ListItem(){
            Row(){
              Text('我是有底线的~')
                .fontColor(Color.Gray)
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .padding(16)
          }
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
      }
      .layoutWeight(1)
    }
    .layoutWeight(1)
    .width('100%')
    .backgroundColor('#ff353333')
    .borderRadius({topLeft:12,topRight:12})
  }
  build() {
    Column() {
      Column(){
        //歌单明细 显示个人的图片 标题 昵称 还有按钮
        this.musicLike()
        //播放列表
        this.musicList()
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#121215')
  }
}