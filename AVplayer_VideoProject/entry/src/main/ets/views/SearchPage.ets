import { common } from '@kit.AbilityKit'

//搜索部分
@Builder export  function SearchRow(){
  //头部搜索部分
  Row() {
    Image($r('app.media.app_icon'))
      .width(30)
      .height(30)
    Search({
      placeholder: $r('app.string.want_search'),
    })
      .searchButton((getContext() as common.UIAbilityContext).resourceManager.getStringSync($r('app.string.search').id),
        { fontSize: 14 })
      .width('100%')
      .height(40)
      .textFont({ size: 14 })
      .placeholderFont({ size: 14 })
      .backgroundColor('#E6E8E9')
      .layoutWeight(1)
      .margin({ left: 16, right: 16 })
    Text($r('app.string.more'))
      .fontSize(14)
  }
  .width('100%')
  .height(60)
  .padding({left:12,right:12})
  .justifyContent(FlexAlign.Center)
}