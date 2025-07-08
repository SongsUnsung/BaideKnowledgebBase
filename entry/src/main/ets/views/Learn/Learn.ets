import { CommonConstant } from '../../contants/CommonConstant'
import { LearnApplicationData } from '../../models/LearnApplicationData'
import { router } from '@kit.ArkUI'
import { RouterConstant } from '../../contants/RouterConstant'
import { ClockComponent } from '../../components/ClockComponent'

@Entry
@Component
export struct Learn {
  // 学习平台应用数据
  @State learnApplicationList: LearnApplicationData[] =
    [{ id: 1, name: '鸿蒙', icon: $r("app.media.icon_learn_hm") },
      { id: 2, name: 'Java', icon: $r("app.media.icon_learn_java") },
      { id: 3, name: 'Web前端', icon: $r("app.media.icon_learn_web") },
      { id: 4, name: '运维', icon: $r("app.media.icon_learn_linux") },]
  // 面试平台数据
  @State interviewApplicationList: LearnApplicationData[] =
    [{ id: 1, name: '鸿蒙面试题', icon: $r("app.media.icon_learn_hm") },
      { id: 2, name: 'Java面试题', icon: $r("app.media.icon_learn_java") },
      { id: 3, name: 'Web前端面试题', icon: $r("app.media.icon_learn_web") },
      { id: 4, name: '运维面试题', icon: $r("app.media.icon_learn_linux") },]
  // 学习工具
  @State clockData: LearnApplicationData[] =
    [{ id: 1, name: '学习打卡', icon: $r("app.media.icon_learn_clock") },
      { id: 2, name: '学习目标', icon: $r("app.media.icon_learn_target") },]
  @State pageTitle: string = '学习'

  @StorageProp('topRectHeight') topRectHeight: number = 0;

  build() {
    Column() {
      Stack({ alignContent: Alignment.BottomStart }) {

        Swiper() {

          Text('欢迎来到学习平台').height($r('app.float.common_height_huge')).fontWeight(FontWeight.Medium)
            .fontColor('#191919')
            .fontSize($r('app.float.common_font_size_big'))
            .backgroundImage($r('app.media.learn_img'))
            .textAlign(TextAlign.Center)
            .width(CommonConstant.WIDTH_FULL)


          Text('学无止境').height($r('app.float.common_height_huge')).fontWeight(FontWeight.Medium)
            .fontColor('#191919')
            .fontSize($r('app.float.common_font_size_big'))
            .backgroundImage($r('app.media.beijingc'))
            .backgroundImageSize(ImageSize.Cover)
            .width(CommonConstant.WIDTH_FULL)
            .padding({left: 20})

          Text('现在开始').height($r('app.float.common_height_huge')).fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .fontSize($r('app.float.common_font_size_big'))
            .backgroundImage($r('app.media.beijingb'))
            .backgroundImageSize(ImageSize.Cover)
            .width(CommonConstant.WIDTH_FULL)
            .padding({left: 20})
        }
        .loop(true)
        .autoPlay(true)
        .interval(1000)
        .borderRadius(16)


      }
      .margin({top:10,left:10,right:10})


      // 小标题
      fontTitleBuilder('学习工具')
      // 学习打卡和学习通知
      Row({ space: 15 }) {
        ForEach(this.clockData, (item: LearnApplicationData) => {
          ClockComponent({ icon: item.icon, text: item.name })
            .onClick(() => {
              if (item.id === 1) {
                // 路由到打卡界面
                router.pushUrl({ url: RouterConstant.VIEWS_LEARN_TOOL })
              } else {
                // 路由到学习目标界面
                router.pushUrl({ url: RouterConstant.VIEWS_LEARN_TARGET })
              }
            })
        })
      }


      // 小标题
      fontTitleBuilder('学习平台')

      // 学习应用平台
      Row({ space: 15 }) {
        ForEach(this.learnApplicationList, (item: LearnApplicationData) => {
          learnApplicationBuilder(item.id, item.icon, item.name)
        })
      }

      // 小标题
      fontTitleBuilder('面试大全')

      // 面试功能
      Row({ space: 15 }) {
        ForEach(this.interviewApplicationList, (item: LearnApplicationData) => {
          interviewApplicationBuilder(item.id, item.icon, item.name)
        })
      }
      // .width(CommonConstant.WIDTH_FULL)

    }
    // .padding($r('app.float.common_padding'))
    .height(CommonConstant.HEIGHT_FULL)
    .width(CommonConstant.WIDTH_FULL)
    .padding({ top: this.topRectHeight })
  }
}

@Builder
function fontTitleBuilder(title: string) {
  Row() {
    Text(title)
      .fontSize($r('app.float.common_font_size_big')).fontWeight(FontWeight.Medium)
      .fontColor('#191919')
  }.width(CommonConstant.WIDTH_FULL).margin({ top: 25, bottom: 15 ,left:20})

}


@Builder
function learnApplicationBuilder(id: number, icon: ResourceStr, text: string) {
  Column({ space: 10 }) {
    Image(icon)
      .width(40).aspectRatio(1)
    Text(text).textStyles()
  }
  .columStyles(id, text)
  .onClick(() => {
    router.pushUrl({ url: RouterConstant.VIEWS_LEARN_CONTENT, params: { "contentCategory": id, "pageTitle": text } })
  })
}

@Builder
function interviewApplicationBuilder(id: number, icon: ResourceStr, text: string) {
  Column({ space: 10 }) {
    Image(icon)
      .width(40).aspectRatio(1)
    Text(text).textStyles()
  }.columStyles(id, text)
  .onClick(() => {
    router.pushUrl({
      url: RouterConstant.VIEWS_INTERVIEW_CONTENT,
      params: { "contentCategory": id, "pageTitle": text }
    })
  })

}

@Extend(Text)
function textStyles() {
  .fontSize($r('app.float.common_font_size_small'))
  .fontColor('#191919')
  .fontWeight(FontWeight.Normal)
}

@Extend(Column)
function columStyles(id: number, text: string) {
  .width(75)
  .height($r('app.float.common_height_big'))
  .backgroundColor($r('app.color.common_white'))
  .justifyContent(FlexAlign.Center)
  .borderRadius(8)
}

