import { CommonConstants } from '../../common/CommonConstants'

/*
在单个源文件中，最多可以使用10个@Preview装饰自定义组件
@Preview({
  title: 'Component1',  //预览组件的名称
  deviceType: 'phone',  //指定当前组件预览渲染的设备类型，默认为Phone
  width: 1080,  //预览设备的宽度，单位：px
  height: 2340,  //预览设备的长度，单位：px
  colorMode: 'light',  //显示的亮暗模式，当前支持取值为light
  dpi: 480,  //预览设备的屏幕DPI值
  locale: 'zh_CN',  //预览设备的语言，如zh_CN、en_US等
  orientation: 'portrait',  //预览设备的横竖屏状态，取值为portrait或landscape
  roundScreen: false  //设备的屏幕形状是否为圆形
})
 */
// @Preview({
//   title: 'demo01preview',
//   deviceType: 'tablet',
//   colorMode: 'dark',
//   dpi: 480,
//   locale: 'en_US',
//   orientation: 'landscape',
//   roundScreen: false
// })

@Entry
@Component
struct Demo01preview {
  build() {
    Column({ space: CommonConstants.Size }) {
      Text($r("app.string.welcome"))
        .fontColor($r("app.color.red"))
      //资源类型
      Image($r("app.media.imgs"))
        .imgstyle()
      //rawflie
      Image($rawfile('startIcon.png'))
        .imgstyle()
      //网络地址
      Image('https://img1.baidu.com/it/u=4035546522,389745751&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1372')
        .imgstyle()
      Text($r("app.string.test"))
        .fontColor(CommonConstants.Size)
    }
    .width('100%')
    .height('100%')
  }
}

//样式抽取
@Extend(Image) function imgstyle(){
  .width(100)
  .height(100)
}