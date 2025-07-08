import { CommonConstant } from '../../contants/CommonConstant'

@Entry
@Component
struct AboutUS {
  @State logoOpacity: number = 0           //Logo的透明度
  @State logoOffset: number = -100         //Logo位置偏移
  @State text1Opacity: number = 0          //文字的透明度
  @State text2Opacity: number = 0
  @State text3Opacity: number = 0
  @StorageProp('topRectHeight') topRectHeight: number = 0;


  aboutToAppear() {
    // Logo动画
    animateTo({
      duration: 800,
      curve: Curve.EaseOut
    }, () => {
      this.logoOpacity = 1
      this.logoOffset = 0
    })

    // 文字动画
    setTimeout(() => {
      animateTo({
        duration: 500,
        curve: Curve.EaseIn
      }, () => {
        this.text1Opacity = 1
      })
    }, 200)

    setTimeout(() => {
      animateTo({
        duration: 500,
        curve: Curve.EaseIn
      }, () => {
        this.text2Opacity = 1
      })
    }, 400)

    setTimeout(() => {
      animateTo({
        duration: 500,
        curve: Curve.EaseIn
      }, () => {
        this.text3Opacity = 1
      })
    }, 600)
  }

  build() {
    Navigation() {
      Column() {
        Column() {
          Image($r("app.media.app_icon"))
            .width($r('app.float.common_width_medium'))
            .borderRadius(30)
            .opacity(this.logoOpacity)
            .translate({ y: this.logoOffset })

          Text($r("app.string.application_name"))
            .fontSize(19)
            .fontColor("#121826")
            .fontWeight(FontWeight.Medium)
            .margin(12)
            .opacity(this.text1Opacity)

          Text($r("app.string.app_description"))
            .fontColor("#6F6F6F")
            .fontSize(14)
            .opacity(this.text2Opacity)

          Text("版本号：V1.0.0")
            .margin(18)
            .fontSize(14)
            .fontColor("#979797")
            .opacity(this.text3Opacity)
        }

        Row() {
          Text('百得知识库是安徽百得思维信息科技有限公司研发的一款编程知识分享的App')
            .fontSize(14)
            .fontColor("#979797")
            .opacity(this.text3Opacity)
        }
      }
      .padding(60)
      .height("100%")
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .titleMode(NavigationTitleMode.Mini)
    .title($r('app.string.about_us_title'))
    .mode(NavigationMode.Stack)
    .height(CommonConstant.HEIGHT_FULL)
    .width(CommonConstant.WIDTH_FULL)
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize({ width: CommonConstant.WIDTH_FULL, height: CommonConstant.HEIGHT_FULL })
    .padding({ top: this.topRectHeight })
  }
}
