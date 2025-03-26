import { LemonModel, temperature_Data,sweetness_Data,add_Materials } from './july_29_model'
import { LengthMetrics } from '@kit.ArkUI'

class sweetness_class{
  sweetness_content:LemonModel = new LemonModel('',0)
  index: number | undefined
  text: ResourceStr = ''
}
@Entry
@Component
struct LemonTea {
  //将温度数据使用状态变量承接
  @State temperature_arr: LemonModel[] = temperature_Data
  //温度区域当前的索引值
  @State temperature_index: number = 0
  //定义订单模块的内容的温度部分
  @State temperature_str: string = '正常冰'
  //将甜度数据使用状态变量承接
  @State sweetness_arr: LemonModel[] = sweetness_Data
  //定义订单模块的内容的甜度部分
  @State sweetness_str: string = '正常糖'
  //甜度区域当前的索引值
  @State sweetness_index:number = 0
  //将加料的数据使用状态变量承接
  @State Materials_arr: LemonModel[] = add_Materials
  //定义订单模块的加料的内容部分
  @State Materials_str: string = ''
  //总价
  @State price_all: number = 15
  //总数量
  @State account_all:number = 1
  build() {
    //最大的盒子
    Column() {
      //内容区域，包含标题、温度、甜度、加料
      Column({ space: 20 }) {
        //标题部分
        Row() {
          //文字标题
          Text('石榴柠檬茶')
          //分享与收藏
          Row({ space: 10 }) {
            Image($r("app.media.fenxiang"))
              .width(20)
            Image($r('app.media.shoucang'))
              .width(20)
          }
        }
        .height(80)
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(15)

        //分割线
        Divider()
          .width('95%')
        //温度
        Row() {
          Text('温度')
            .width(80)
            .height(60)
            .textAlign(TextAlign.Center)
            .align(Alignment.Top)
            .padding({ top: 5 })
          Flex({wrap:FlexWrap.Wrap,space:{main:{value:20,unit:1},cross:LengthMetrics.vp(10)}}){
            ForEach(this.temperature_arr,(item:LemonModel) => {
              temperature_Item({
                //温度模块的内容数据
                temperature_content:item ,
                //温度模块的当前索引
                index:this.temperature_index,
                //温度模块需要渲染的文字内容
                text:this.temperature_str
              })

            },(item:LemonModel) => JSON.stringify(item))
          }
          .width(260)
          .height(60)
        }
        .width('100%')

        //甜度
        Row() {
          Text('甜度')
            .width(80)
            .height(60)
            .textAlign(TextAlign.Center)
            .align(Alignment.Top)
            .padding({ top: 5 })
          Flex({wrap:FlexWrap.Wrap,space:{main:{value:20,unit:1},cross:LengthMetrics.vp(10)}}){
            ForEach(this.sweetness_arr,(item:LemonModel) => {
              //调用甜度区域模块，并使用按引用传递将需要的值传过去
              sweetness_Item({
                //甜度模块的内容是数据
                sweetness_content: item,
                //甜度模块当前的索引值
                index: this.sweetness_index,
                //甜度模块的文本渲染内容
                text: this.sweetness_str
              })
            },(item:LemonModel) => JSON.stringify(item))
          }
          .width(260)
          .height(60)
        }
        .width('100%')

        //加料区
        //甜度
        Row() {
          Text('加料')
            .width(80)
            .height(120)
            .textAlign(TextAlign.Center)
            .align(Alignment.Top)
            .padding({ top: 5 })
          Column({space:10}){
            ForEach(this.Materials_arr,(item: LemonModel) => {
              //调用加料模块
              Materials_Item({
                //加料的每一个内容数据
                Materials_content: item,
                //加料需要渲染的文本内容
                text: this.Materials_str,
                //加料模块的所有数据 数组
                Materials_arr:this.Materials_arr,
                //一杯的价格，会因为加料的不同而改变
                price: this.price_all
              })
            },(item:LemonModel) => JSON.stringify(item))
          }
          .height(120)
        }
        .width('100%')
      }
      .height('100%')
      .height('85%')

      //底部下订单区域
      Column({space:10}) {
        //价格与数量
        Row(){
          //总价 = 一杯的价格 * 总数量
          Text(`￥${this.price_all * this.account_all}`)
          Row(){
            Image($r('app.media.shanchu'))
              .width(15)
              .onClick(() => {
                this.account_all--
                if(this.account_all < 1){
                  this.account_all = 1
                }
              })
            Text(`${this.account_all}`)
            Image($r('app.media.tianjia'))
              .width(15)
              .onClick(() => {
                this.account_all++
              })
          }
          .width(70)
          .justifyContent(FlexAlign.SpaceBetween)

        }
        .width('100%')
        .height(30)
        .justifyContent(FlexAlign.SpaceBetween)
        //调用从两个模块传递过来的内容进行拼接
        Text(`${this.temperature_str}${',' + this.sweetness_str},${this.Materials_str}`)
          .width('100%')
          .fontColor('#81838f')
        Row(){
          Text('立即购买')
            .width('45%')
            .border({
              width:1,
              color:'#c7c7c7'
            })
            .height(40)
            .textAlign(TextAlign.Center)
            .fontSize(18)
            .borderRadius(8)
          Text('加入购物车')
            .width('45%')
            .height(40)
            .textAlign(TextAlign.Center)
            .fontSize(18)
            .backgroundColor('#80b439')
            .fontColor(Color.White)
            .borderRadius(8)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .height('15%')
      .width('100%')
      .height('15%')
      .padding({ left:20, right:20 })
      .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f2f3')
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}

//温度模块,因为需要使用@ObjectLink,故写成自定义组件形式
@Component
struct temperature_Item{
  //数据模块定义，值由父级传递
  @ObjectLink temperature_content:LemonModel
  //当前的索引
  @Link index: number | undefined
  //温度模块的文本内容
  @Link text: ResourceStr
  build() {
    Text(this.temperature_content.title)
      .textAlign(TextAlign.Center)
      .fontSize(14)
      .width(50)
      .height(30)
      .border({
        width:2,
        color: this.temperature_content.index === this.index ?
          '#5eb92b' : '#cdcdcd'
      })
      .backgroundColor(this.temperature_content.index === this.index ?
        '#eaffe0' : '#cdcdcd')
      .borderRadius(8)
      .onClick(() => {
        this.index = this.temperature_content.index
        this.text = this.temperature_content.title
      })
  }
}

//甜度模块的自定义函数
//因为甜度模块与温度模块布局内容相同且数据互相独立
//所以使用温度模块的自定义组件且传入自己的数据进行覆盖
@Builder
function sweetness_Item($$:sweetness_class){
  temperature_Item({
    temperature_content:$$.sweetness_content,
    index:$$.index,
    text:$$.text
    // index: index,
  })
}

//加料模块
@Component
struct Materials_Item{
  //加料的每一个内容数据
  @ObjectLink Materials_content:LemonModel
  //加料的文本渲染内容
  @Link text: string
  //加料的内容数据 数组
  @Link Materials_arr: LemonModel[]
  //一杯的价格
  @Link price: number
  //计算所需要渲染的内容,每次点击都重新循环计算
  text_add(){
    let text:string = ''
    this.Materials_arr.map((item: LemonModel) => {
      item.flg ? text += ',' + item.title : text
    })
    return text
  }

  build() {
    Row(){
      Text(this.Materials_content.title + `￥${this.Materials_content.index}`)
      Image(this.Materials_content.flg ?
      $r('app.media.shanchu') : $r('app.media.tianjia'))
        .width(15)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left:5, right:5 })
    .width(260)
    .height(30)
    .border({ width:2, color: this.Materials_content.flg ? '#5eb92b' : '#dadada' })
    .backgroundColor(this.Materials_content.flg ?
      '#eaffe0' : '#f1f2f3')
    .borderRadius(8)
    .onClick(() => {
      //点击之后对当前的状态取反
      this.Materials_content.flg = !this.Materials_content.flg
      //点击之后重新调用内容渲染函数计算
      this.text = this.text_add()
      //点击之后判断是否状态为true，
      //如果为true则将该材料的价格计算进一杯的价格中
      if(this.Materials_content.flg){
        this.price += this.Materials_content.index
      }else{
        //如果为false则将该材料的价格从一杯的价格中减去
        this.price -= this.Materials_content.index
      }
    })
  }
}