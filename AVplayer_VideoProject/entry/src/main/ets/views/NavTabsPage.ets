import { songs, swiperImageText, swiperList } from "../constants/MusicConstants";
import {  SongItemType } from "../models/Index";
import { router } from "@kit.ArkUI";
import { AVPlayerUtils } from "../utils/AVPlayerUtils";

@Preview
@Component
export struct NavTabsPage {
  @State NavcurrentIndex: number = 0;
  private NavtabsController: TabsController = new TabsController();
  //轮播图
  @Builder
  SwiperComponent(){
    Swiper(){
      ForEach(swiperList,(item:swiperImageText) => {
        Stack(){
          Image(item.image)
          Text(item.text)
            .width('70%')
            .padding(10)
            .fontSize(14)
            .fontColor(Color.White)
            .maxLines(1)
            .textOverflow({overflow:TextOverflow.Ellipsis})
        }
        .width('100%')
        .height('100%')
        .alignContent(Alignment.BottomStart)
      })
    }
    .width('100%')
    .height('180')
    .borderRadius(5)
    .indicator(
      new DotIndicator()
        .right(10)
    )
  }
  //视频列表区
  @Builder
  VideoComponent(){
    List(){
      ForEach(songs,(item:SongItemType,index) => {
        ListItem(){
          Column({space:12}){
            //图片展示和播放量 点赞数
            Stack(){
              //图片展示
              Image(item.img)
                .width('100%')
                .height('150')
                .objectFit(ImageFit.Cover)
              //播放量和 点赞数
              Row(){
                Row(){
                  Image($r('app.media.playNumber'))
                    .width(16)
                    .fillColor('#f1f2f3')
                    .margin({right:5})
                  Text('18.8万')
                    .fontSize(10)
                    .fontColor(Color.White)
                }
                Row(){
                  Image($r('app.media.upvote'))
                    .width(16)
                    .fillColor('#f1f2f3')
                    .margin({right:5})
                  Text('334.5万')
                    .fontSize(10)
                    .fontColor(Color.White)
                }
              }
              .width('100%')
              .padding(7)
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .alignContent(Alignment.Bottom)
            Text(item.name)
              .width('100%')
              .padding({left:8})
              .fontSize(14)
              .textAlign(TextAlign.Start)
              .textOverflow({overflow:TextOverflow.Ellipsis})
              .maxLines(2)
              .fontWeight(500)
            //播放量和 点赞数
            Row(){
              Row(){
                Image($r('app.media.UP'))
                  .width(16)
                  .fillColor('#a6a6a6')
                  .margin({right:5})
                Text(item.author)
                  .width('50%')
                  .fontSize(13)
                  .fontColor('#a6a6a6')
                  .maxLines(1)
                  .fontWeight(500)
                  .textOverflow({overflow:TextOverflow.Ellipsis})
              }
              Row(){
                Image($r('app.media.ic_more'))
                  .width(14)
                  .fillColor('#a6a6a6')
                  .margin({right:5})
              }
            }
            .width('100%')
            .padding({left:8})
            .justifyContent(FlexAlign.SpaceBetween)
          }
        }
        .width('100%')
        .borderRadius(8)
        .clip(true)
        .margin({bottom:10})
        .backgroundColor('#fff')
        .onClick(() => {
          AVPlayerUtils.ChangeplayIndex(item)
          router.pushUrl({
            url:"pages/PlayingPage"
          })
        })
      })
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
    .width('100%')
    .lanes(2,5)
    .scrollBar(BarState.Off)
  }
  //结构体
  build() {
    Tabs({barPosition: BarPosition.Start, controller: this.NavtabsController }){
      TabContent(){
        Scroll(){
          Column({space:5}){
            //轮播图
            this.SwiperComponent()
            //视频列表区
            this.VideoComponent()
          }
          .padding(5)
          .width('100%')
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
      }
      .tabBar('推荐')
      .backgroundColor('#f1f2f3')
      TabContent(){
        Text('热门')
      }.tabBar('热门')
      TabContent(){
        Text('追番')
      }.tabBar('追番')
      TabContent(){
        Text('影视')
      }.tabBar('影视')
      TabContent(){
        Text('新征程')
      }.tabBar('新征程')
      TabContent(){
        Text('直播')
      }.tabBar('直播')
    }
    .barMode(BarMode.Fixed)
    .onChange((index: number) => {
      this.NavcurrentIndex = index;
    })
  }
}