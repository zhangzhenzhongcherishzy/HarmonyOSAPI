@Entry
@Component
struct DatePickers {
  @State dates:Date = new Date()
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder:stuDent({selectedDate:this.dates}),
  })
  build() {
    Column() {
      Text(`${this.dates.getFullYear()}年${this.dates.getMonth()+1}月${this.dates.getDate()}日`)
      Button('选择时间')
        .onClick(() => {
          this.dialogController?.open()
        })
    }
    .padding(12)
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f2f3')
  }
}

@CustomDialog
struct stuDent {
  controller?: CustomDialogController
  @Link selectedDate: Date
  build() {
    Column(){
      Text(this.selectedDate.toString())
      DatePicker({
        start: new Date('1970-1-1'),
        end: new Date('2100-1-1'),
        selected: this.selectedDate
      })
        .onDateChange((value: Date) => {
          this.selectedDate = value
          console.info('select current date is: ' + value.toString())
        })
      Button('点我关闭弹窗')
        .onClick(() => {
          if (this.controller != undefined) {
            this.controller.close()
          }
        })
        .margin(20)
    }
  }
}