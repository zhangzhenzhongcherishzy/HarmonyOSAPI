// common/breakpointsystem.ets
import { mediaquery } from '@kit.ArkUI'

//断点类型
export type BreakpointType = 'xs' | 'sm' | 'md' | 'lg' | 'xl' | 'xxl'

//断点
export interface Breakpoint {
  //类型
  name: BreakpointType
  //值
  size: number
  //媒体查询的句柄，并包含了申请句柄时的首次查询结果。媒体查询根据设置的条件语句，
  // 比如'(width <= 600vp)'，比较系统信息，若首次查询时相关信息未初始化，matches返回false。
  mediaQueryListener?: mediaquery.MediaQueryListener
}

// 断点查询方法类
export class BreakpointSystem {
  private static instance: BreakpointSystem
  //断点值
  private readonly breakpoints: Breakpoint[] = [
    { name: 'xs', size: 0 },
    { name: 'sm', size: 320 },
    { name: 'md', size: 600 },
    { name: 'lg', size: 840 }
  ]
  //是一系列无序，没有重复数值的数据集合。
  private states: Set<BreakpointState<Object>>

  private constructor() {
    this.states = new Set()
  }
//获得实例
  public static getInstance(): BreakpointSystem {
    if (!BreakpointSystem.instance) {
      BreakpointSystem.instance = new BreakpointSystem();
    }
    return BreakpointSystem.instance
  }

  //增加状态
  public attach(state: BreakpointState<Object>): void {
    this.states.add(state)
  }

  //删除状态
  public detach(state: BreakpointState<Object>): void {
    this.states.delete(state)
  }

  public start() {
    this.breakpoints.forEach((breakpoint: Breakpoint, index) => {
      //条件
      let condition: string
      if (index === this.breakpoints.length - 1) {
        condition = `(${breakpoint.size}vp<=width)`
      } else {
        condition = `(${breakpoint.size}vp<=width<${this.breakpoints[index + 1].size}vp)`
      }
      //设置媒体查询的查询条件，并返回对应的监听句柄。
      //mediaQueryListener 媒体查询的句柄，并包含了申请句柄时的首次查询结果。
      // 媒体查询根据设置的条件语句，比如'(width <= 600vp)'，
      // 比较系统信息，若首次查询时相关信息未初始化，matches返回false。
      breakpoint.mediaQueryListener = mediaquery.matchMediaSync(condition)
      if (breakpoint.mediaQueryListener.matches) {
        //更新状态
        this.updateAllState(breakpoint.name)
      }
      breakpoint.mediaQueryListener.on('change', (mediaQueryResult) => {
        if (mediaQueryResult.matches) {
          console.log(`当前屏幕状态态为:${breakpoint.name}`)
          console.log(`当前屏幕大小为:${breakpoint.size}`)
          AppStorage.setOrCreate('currentBreakpoint',breakpoint.name)
          //监听并更新状态
          this.updateAllState(breakpoint.name)

        }
      })
    })
  }

  private updateAllState(type: BreakpointType): void {
    this.states.forEach((state): Object | undefined => state.update(type))
  }

  public stop() {
    //停止监听并清除状态
    this.breakpoints.forEach((breakpoint: Breakpoint, index) => {
      if (breakpoint.mediaQueryListener) {
        breakpoint.mediaQueryListener.off('change')
      }
    })
    this.states.clear()
  }
}

export interface BreakpointOptions<T> {
  xs?: T
  sm?: T
  md?: T
  lg?: T
  xl?: T
  xxl?: T
}

export class BreakpointState<T extends Object> {
  public value: T | undefined = undefined;
  private options: BreakpointOptions<T>

  constructor(options: BreakpointOptions<T>) {
    this.options = options
  }

  static of<T extends Object>(options: BreakpointOptions<T>): BreakpointState<T> {
    return new BreakpointState(options)
  }

  public update(type: BreakpointType) {
    if (type === 'xs') {
      //this.options.xs 开发者给予的值
      this.value = this.options.xs
      return this.value
    } else if (type === 'sm') {
      this.value = this.options.sm
      return this.value
    } else if (type === 'md') {
      this.value = this.options.md
      return this.value
    } else if (type === 'lg') {
      this.value = this.options.lg
      return this.value
    } else if (type === 'xl') {
      this.value = this.options.xl
      return this.value
    } else if (type === 'xxl') {
      this.value = this.options.xxl
      return this.value
    } else {
      this.value = undefined
      return this.value
    }
  }
}
// 创建断点枚举类，提供静态常量表示不同的断点
export class BreakpointTypeEnum {
  static readonly SM: string = 'sm'; // 小屏幕断点
  static readonly MD: string = 'md'; // 中等屏幕断点
  static readonly LG: string = 'lg'; // 大屏幕断点
}



