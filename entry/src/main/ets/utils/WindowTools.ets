import { window } from "@kit.ArkUI";
import { BusinessError } from "@kit.BasicServicesKit";
import { JSON } from "@kit.ArkTS";

export default class WindowTools {
  private static instance: WindowTools;
  private windowStage: window.Window | undefined = undefined

  static getInstance() {
    if (!WindowTools.instance) {
      WindowTools.instance = new WindowTools();
    }
    return WindowTools.instance;
  }

  // todo 获取主窗口
  setWindowStage(windowStage: window.Window): void {
    this.windowStage = windowStage;
    // todo 注册窗口变化监听函数
    WindowTools.instance.registerOnWindowSizeChange()
    // todo 获取状态栏高度，和导航条高度
    WindowTools.instance.getStatusBarHeight()
    // todo 获取页面高度
    // WindowTools.getInstance().setPageHeight()
  }

  // todo 设置主窗口的旋转
  setMainWindowOrientation(orientation: window.Orientation): void {
    if (this.windowStage === undefined) {
      return;
    }
    // todo 设置窗口旋转方向
    this.windowStage.setPreferredOrientation(orientation).then(() => {

    }).catch((err: BusinessError) => {
    })
  }

  // todo 监听窗口变化
  /**
 * 注册窗口大小变化和避让区域变化的事件监听
 *
 * 本函数旨在响应窗口大小的变化和避让区域的变化，以适应不同的设备环境
 * 它通过监听两个事件，分别处理窗口大小的改变和避让区域的改变，并将相关
 * 信息存储到应用的存储系统中，以便其他部分可以访问这些数据
 */
registerOnWindowSizeChange() {
  // 检查windowStage是否已定义，若未定义则直接返回，不执行后续操作
  if (this.windowStage === undefined) {
    return;
  }

  // 监听窗口大小变化事件
  this.windowStage.on('windowSizeChange', (size) => {
    // 当窗口大小发生变化时，判断当前设备是横屏还是竖屏，并存储该信息
    AppStorage.setOrCreate("isLan", size.width > size.height)
    // 存储设备的宽度和高度，以便在其他地方使用
    AppStorage.setOrCreate('deviceWidth',px2vp(size.width));
    AppStorage.setOrCreate('deviceHeight',px2vp(size.height))
    // TODO: 获取页面高度
    // WindowTools.getInstance().setPageHeight()
  });

  // 监听避让区域变化事件
  this.windowStage.on('avoidAreaChange', (data) => {
    // 打印避让区域变化的信息，用于调试
    console.log("avoidAreaChange修改", JSON.stringify(data.area));
    // 根据避让区域的类型，分别处理系统区域和导航指示器区域的变化
    if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
      let topRectHeight = data.area.topRect.height;
      // 打印系统避让区域的信息，用于调试
      console.log("显示toprect",JSON.stringify(data.area))
      // 存储顶部避让区域的高度
      AppStorage.setOrCreate('topRectHeight', px2vp(topRectHeight));
    } else if (data.type == window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
      let bottomRectHeight = data.area.bottomRect.height;
      // 存储底部避让区域的高度
      AppStorage.setOrCreate('bottomRectHeight',px2vp(bottomRectHeight) );
    }
  })
}


  // todo 取消监听窗口变化
  registerOffWindowSizeChange() {
    if (this.windowStage === undefined) {
      return;
    }
    this.windowStage.off('windowSizeChange');
  }

  // todo 设置窗口全屏
  setFullScreen(enable: boolean) {
    if (this.windowStage === undefined) {
      return;
    }
    this.windowStage.setWindowLayoutFullScreen(enable)
  }

  // todo 获取状态栏高度，和导航条高度
  getStatusBarHeight() {
    if (this.windowStage === undefined) {
      return
    }
    // 2. 获取布局避让遮挡的区域
    let type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR; // 以导航条避让为例
    let avoidArea = this.windowStage.getWindowAvoidArea(type);
    let bottomRectHeight = avoidArea.bottomRect.height; // 获取到导航条区域的高度
    AppStorage.setOrCreate('bottomRectHeight', px2vp(bottomRectHeight));

    type = window.AvoidAreaType.TYPE_SYSTEM; // 以状态栏避让为例
    avoidArea = this.windowStage.getWindowAvoidArea(type);
    let topRectHeight = avoidArea.topRect.height; // 获取状态栏区域高度
    AppStorage.setOrCreate('topRectHeight',px2vp(topRectHeight));


    const properties = this.windowStage.getWindowProperties();
    // todo 获取设备高度
    AppStorage.setOrCreate('deviceWidth',px2vp(properties.windowRect.width));
    // todo 获取设备宽度
    AppStorage.setOrCreate('deviceHeight',px2vp(properties.windowRect.height) );
  }
  // todo 单独获取设备的高度
  // setPageHeight(){
  //   let deviceHeight = AppStorage.get('deviceHeight') as number
  //   // todo 获取设备高度
  //   let statusBarHeight =  AppStorage.get('topRectHeight') as number;
  //   // todo 获取状态栏高度
  //   let navBarHeight = AppStorage.get('bottomRectHeight') as number;
  //   console.log("显示设备", deviceHeight-statusBarHeight-navBarHeight)
  //   console.log("显示设备1", deviceHeight,statusBarHeight,navBarHeight)
  //   AppStorage.setOrCreate('pageHeight',deviceHeight - statusBarHeight - navBarHeight)
  //
  //
  // }
}