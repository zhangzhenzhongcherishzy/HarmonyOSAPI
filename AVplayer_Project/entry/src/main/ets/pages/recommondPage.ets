import { dailyRecommend, recommendList, swiperList } from "../constants/MusicConstants"
import { RecommendDailyType, RecommendListType } from "../models/Index"

@Entry
@Component
export struct recommondPage {
  /**
   *  搜索框
   */
  @Builder
  SearchInputComponent() {
    Row() {
      Row({ space: 4 }) {
        Image($r('app.media.ic_search'))
          .width(20)
          .aspectRatio(1)
          .fillColor('#7a828e')
        Text('听妈妈的话🔥')
          .fontColor('#7a828e')
          .layoutWeight(1)
        Image($r('app.media.ic_code'))
          .width(20)
          .aspectRatio(1)
          .fillColor('#7a828e')
      }
      .width('100%')
      .padding(12)
      .borderRadius(60)
      .backgroundColor('#ffeeee')
    }
    .width('100%')
    .padding(12)
  }

  /**
   * 轮播图
   */
  @Builder
  SwipperComponent() {
    Row() {
      Swiper() {
        ForEach(swiperList, (item: string) => {
          Row() {
            Image(item)
              .width('100%')
              .height(160)
          }
          .borderRadius(8)
          .clip(true)
        })
      }
      .autoPlay(true)
    }
    .width('100%')
    .padding(8)
  }

  //标题部分
  @Builder TitleBar(title:string){
    //标题部分
    Row() {
      Text(title)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Gray)
      Text('更多')
        .fontColor(Color.Gray)
    }
    .width('100%')
    .padding(8)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  /**
   * 每日推荐
   */
  @Builder
  DailyRecomment() {
    Column() {
      this.TitleBar('每日推荐')
      //内容部分
      Row() {
        Scroll() {
          Row({ space: 10 }) {
            ForEach(dailyRecommend, (item: RecommendDailyType) => {
              Column() {
                Text(item.type)
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
                  .fontSize(12)
                  .padding(8)
                  .backgroundColor(item.top)
                Image(item.img)
                  .width('100%')
                  .aspectRatio(1)
                Text(item.title)
                  .width('100%')
                  .fontSize(12)
                  .padding(12)
                  .fontColor('#ffe9dfdf')
                  .backgroundColor(item.bottom)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(2)
              }
              .width('40%')
              .borderRadius(8)
              .clip(true)
            })
          }
        }
        .width('100%')
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Horizontal)
      }
    }.padding({left:8,right:8}).clip(true)
  }

  /**
   * 推荐歌单
   */
  @Builder
  RecommentListComponent(){
    Column(){
      this.TitleBar('推荐歌单')
      Row(){
        Scroll(){
          Row({space:8}){
            ForEach(recommendList,(item:RecommendListType) => {
              Column(){
                Row(){
                  Image(item.img)
                    .width('100%')
                    .borderRadius(8)
                    .aspectRatio(1)
                  Text(item.count)
                    .fontColor(Color.White)
                    .fontSize(12)
                    .fontWeight(FontWeight.Bold)
                    .position({x:6,y:6})
                }
                Text(item.title)
                  .textAlign(TextAlign.Start)
                  .fontSize(12)
                  .fontColor(Color.Gray)
                  .maxLines(2)
                  .textOverflow({overflow:TextOverflow.Ellipsis})
                  .margin({top:8})
              }
              .width('30%')
              .justifyContent(FlexAlign.SpaceBetween)
            })
          }
        }
        .width('100%')
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Horizontal)
      }
    }.padding({left:8,right:8}).clip(true)
  }
  build() {
    Column() {
      //搜索框
      this.SearchInputComponent()
      //轮播图
      this.SwipperComponent()
      //每日推荐
      this.DailyRecomment()
      //推荐歌单
      this.RecommentListComponent()
    }
    .width('100%')
    .height('100%')
  }
}