@Entry
@Component
struct GridRow_Col {
  @State message: string = 'Hello World';
  @State current:string = 'unKnown'
  build() {
    /*
     * 栅格布局
     *    根据设备的水平宽度，将不同屏幕的尺寸划分为不同数量的栅格
     *    来实现屏幕的自适应
     *    栅格是多设备场景下通用的辅助定位工具
     *    通过将空间分割为有规律的栅格。显著降低适配不同屏幕尺寸
     *    的设计及开发成本,使得整体设计和开发流程更有秩序和节奏感
     *
     * */
    /*
     * 栅格容器的断点
     *    提供了丰富的断点定制功能
     *    开发者可以修改断点取值范围，支持启用最多6个断点
     *    value:['100vp','200vp']
     *        表示启动xs 、 sm 、 md 三个断点
     *        小于100vp的为xs,100vp - 200vp sm 200vp以上的为md
     *    value:['320vp','520vp','840vp','1080vp']
     *        表示启动 xs,sm,md,lg,xl 五个断点
     *
     * */
    Column(){
      GridRow({
        breakpoints:{
          //自定义断点范围，最多不超过5个
          value:['200vp','300vp','400vp','500vp','600vp'],
          //判断的目标 WindowSize窗口大小 ComponentSize组件大小
          reference:BreakpointsReference.WindowSize
        },
        //规定特定断点下将容器分割为多少个栅格
        columns:{
          xs:2,
          sm:4,
          md:8,
          lg:12,
          xl:16,
          xxl:20
        },
        //栅格与栅格之间的间距
        gutter:{
          x:'12vp'
        }
      }){
        GridCol({
          //占据多少栅格
          span:{
            xs:2,
            sm:4,
            md:1,
            lg:8,
            xl:12,
            xxl:12
          },
          //偏移多少栅格
          offset:{
            xs:0,
            sm:0,
            md:0,
            lg:2,
            xl:2,
            xxl:4
          }
        }){
          Column(){
            Text(this.current)
              .fontSize(30)
          }
          .border({
            width:1
          })

        }
        GridCol({
          //占据多少栅格
          span:{
            xs:2,
            sm:4,
            md:6,
            lg:8,
            xl:12,
            xxl:12
          },
          //偏移多少栅格
          offset:{
            xs:0,
            sm:0,
            md:0,
            lg:2,
            xl:2,
            xxl:4
          }
        }){
          Column(){
            Text(this.current)
              .fontSize(30)
          }
          .border({
            width:1
          })

        }
        GridCol({
          //占据多少栅格
          span:{
            xs:2,
            sm:4,
            md:1,
            lg:8,
            xl:12,
            xxl:12
          },
          //偏移多少栅格
          offset:{
            xs:0,
            sm:0,
            md:0,
            lg:2,
            xl:2,
            xxl:4
          }
        }){
          Column(){
            Text(this.current)
              .fontSize(30)
          }
          .border({
            width:1
          })

        }

      }
      .onBreakpointChange((currentBreakpoint:string) => {
        this.current = currentBreakpoint
      })
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}