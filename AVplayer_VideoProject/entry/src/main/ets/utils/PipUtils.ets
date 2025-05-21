import { PiPWindow } from "@kit.ArkUI";
import { BusinessError } from "@kit.BasicServicesKit";
import { AVPlayerUtils } from "./AVPlayerUtils";

//画中画工具类
export class PipUtils {
  //创建画中画控制器用于承接画中画实例对象
  static PipController?: PiPWindow.PiPController = undefined

  //创建画中画
  static async startPip(xComponentController: XComponentController) {
    //从ui中获取PiPwindow，通过window窗口进行创建 配置项
    let config: PiPWindow.PiPConfiguration = {
      context: getContext(),
      //传入视频的控制器
      componentController: xComponentController,
      //指定路由跳转的页面id，控制画中画恢复到哪个页面上去 不是必须的，单页面的时，默认单页面，当我们使用router路由时，可以不设置此id，但播放页面时尽量不要切换页面
      // navigationId:""
      //类型:画中画支持不能类型，其中有 视频播放，视频通话，视频会议，直播登
      templateType: PiPWindow.PiPTemplateType.VIDEO_PLAY,
      //指定画中画大小
      contentWidth: 1920,
      contentHeight: 1080,
      //默认指定一些自带的播放控件  上一首 下一首，不能跟快进快退同时进行设置
      controlGroups: [PiPWindow.VideoPlayControlGroup.VIDEO_PREVIOUS_NEXT]
    }
    //创建画中画实例
    PipUtils.PipController = await PiPWindow.create(config)
    PipUtils.PipController.startPiP().then(() => {
      PipUtils.initPipController()
      console.log('开启画中画成功')
    }).catch((err: BusinessError) => {
      console.log('开启画中画失败' + err.message)
    })
  }

  //初始化，监听状态
  static initPipController() {
    if (!PipUtils.PipController) {
      return
    }
    //是否自动开始画中画  退出到桌面是否自动开启画中画
    PipUtils.PipController.setAutoStartEnabled(true)
    //监听启动状态
    PipUtils.PipController.on('stateChange', (state: PiPWindow.PiPState, reason: string) => {
      PipUtils.onStateChange(state, reason)
    })
    //监听状态机
    PipUtils.PipController.on('controlPanelActionEvent', (event: PiPWindow.PiPActionEventType, state: number) => {
      PipUtils.onActionEvent(event, state)
    })
  }

  //启动状态
  static onStateChange(state: PiPWindow.PiPState, reason: string) {
    switch (state) {
      case PiPWindow.PiPState.ABOUT_TO_START:
        console.log(`画中画目前所处状态为：将要启动${state}`)
        break
      case PiPWindow.PiPState.STARTED:
        console.log(`画中画目前所处状态为：已经启动${state}`)
        AVPlayerUtils.play()
        break
      case PiPWindow.PiPState.ABOUT_TO_STOP:
        console.log(`画中画目前所处状态为：将要停止的时候${state}`)
        break
      case PiPWindow.PiPState.STOPPED:
        console.log(`画中画目前所处状态为：已经停止${state}`)
        AVPlayerUtils.play()
        break
      case PiPWindow.PiPState.ABOUT_TO_RESTORE:
        console.log(`画中画目前所处状态为：从小窗口恢复到原始窗口${state}`)
        break
      case PiPWindow.PiPState.ERROR:
        console.log(`画中画目前所处状态为：${state}`)
        break
    }
  }

  //状态机
  static onActionEvent(event: PiPWindow.PiPActionEventType, state: number) {
    switch (event) {
      //播放状态发生改变
      case 'playbackStateChanged':
        if (state == 0) { //开始或停止视频
          AVPlayerUtils.pause()
          console.log('停止了视频')
        } else if (state == 1) {
          AVPlayerUtils.play()
          console.log('播放了视频')
        }
        break
    //播放下一个视频
      case 'nextVideo':
        AVPlayerUtils.next()
        break
    //播放上一个视频
      case 'previousVideo':
        AVPlayerUtils.prev()
        break
    //快进
      case 'fastForward':
        break
    //快退
      case 'fastBackward':
        break
    }
  }

  //调整画布大小
  static upScreenSize(width: number, height: number) {
    if (PipUtils.PipController) {
      PipUtils.PipController.updateContentSize(width, height)
    }
  }

  //关闭画中画 ，手机系统自带，不需要自己封装
  static stopPip() {
    if (PipUtils.PipController) {
      PipUtils.PipController.stopPiP().then(() => {
        //处理关闭事件
        PipUtils.PipController?.off('stateChange')
        PipUtils.PipController?.off('controlPanelActionEvent')
      }).catch((err: BusinessError) => {
        console.log('关闭画中画失败' + err.message)
      })
    }
  }
}