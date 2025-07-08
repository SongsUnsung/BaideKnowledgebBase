import { CommonConstant } from '../contants/CommonConstant';
import { router } from '@kit.ArkUI';
import { RouterConstant } from '../contants/RouterConstant';
import { PreferencesUtil } from '../utils/PreferencesUtil';

@Entry
@Component
struct Advertising {
  // 展示开屏页面时间,单位秒
  @State countDownSeconds: number = CommonConstant.ADVERTISING_TIME;
  // 结束时间,单位秒
  endTime: number = CommonConstant.ADVERTISING_END_TIME;
  // 控制跳过按钮显示
  @State showSkipButton: boolean = false;

  /**
   * 生命周期函数
   */
  onPageShow() {
    this.endTime = setInterval(async () => {
      if (this.countDownSeconds === CommonConstant.ADVERTISING_END_TIME) {
        // 清除定时器
        clearInterval(this.endTime);
        // 获取对应的token等数据
        const token = PreferencesUtil.getData(CommonConstant.PREFERENCES_NAME, CommonConstant.TOKEN_NAME, '')
        const userInfo = PreferencesUtil.getData(CommonConstant.PREFERENCES_NAME, CommonConstant.USER_INFO, '')
        if (token && userInfo) {
          AppStorage.setOrCreate(CommonConstant.TOKEN_NAME, token)
          AppStorage.setOrCreate(CommonConstant.USER_INFO, JSON.parse(userInfo))
        }
        // 跳转到登录页
        router.replaceUrl({ url: RouterConstant.PAGE_LOGIN })
      } else {
        this.countDownSeconds--;
        // 当倒计时开始1秒后显示跳过按钮
        if (this.countDownSeconds === CommonConstant.ADVERTISING_TIME - 1) {
          this.showSkipButton = true;
        }
      }
    }, 1000);
  }

  /**
   * 生命周期函数：隐藏页面
   */
  onPageHide() {
    // 清除定时任务
    clearInterval(this.endTime);
  }

  /**
   * 跳过广告
   */
  skipAdvertising() {
    clearInterval(this.endTime);
    const token = PreferencesUtil.getData(CommonConstant.PREFERENCES_NAME, CommonConstant.TOKEN_NAME, '')
    const userInfo = PreferencesUtil.getData(CommonConstant.PREFERENCES_NAME, CommonConstant.USER_INFO, '')
    if (token && userInfo) {
      AppStorage.setOrCreate(CommonConstant.TOKEN_NAME, token)
      AppStorage.setOrCreate(CommonConstant.USER_INFO, JSON.parse(userInfo))
    }
    router.replaceUrl({ url: RouterConstant.PAGE_LOGIN })
  }

  build() {
    Column() {
      // 合并倒计时和跳过按钮为一个整体
      if (this.showSkipButton) {
        Row() {
          // 跳过文本
          Text('跳过')
            .fontColor($r('app.color.common_white'))
            .fontSize($r('app.float.common_font_size_medium'))

          // 倒计时显示
          Text(this.countDownSeconds.toString() + 's')
            .fontColor($r('app.color.common_white'))
            .fontSize($r('app.float.common_font_size_medium'))
            .margin({ left: 5 })
        }
        .height($r('app.float.common_height_tiny'))
        .backgroundColor($r('app.color.common_gray'))
        .borderRadius(20) // 使用更大的圆角使整体更圆润
        .padding({ left: 12, right: 12, top: 3, bottom: 3 })
        .onClick(() => {
          this.skipAdvertising();
        })
        .justifyContent(FlexAlign.Center)
      }
    }
    .padding($r('app.float.common_padding'))
    .width(CommonConstant.WIDTH_FULL)
    .alignItems(HorizontalAlign.End)
    .height(CommonConstant.HEIGHT_FULL)
    .width(CommonConstant.WIDTH_FULL)
    .backgroundImage($r('app.media.advertising'))
    .backgroundImageSize({ width: CommonConstant.WIDTH_FULL, height: CommonConstant.HEIGHT_FULL })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}