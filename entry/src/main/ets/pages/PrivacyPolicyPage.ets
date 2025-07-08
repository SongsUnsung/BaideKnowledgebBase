import { webview } from '@kit.ArkWeb'
import { CommonConstant } from '../contants/CommonConstant'

@Entry
@Component
struct PolicyPage {

  @StorageProp('topRectHeight') topRectHeight: number = 0;
  webViewController: webview.WebviewController = new webview.WebviewController

  build() {
    //创建一个导航容器
    Navigation() {
      //在导航中加载本地网页文件
      Web({
        src: $rawfile("PrivacyPolicy.html"),
        controller: this.webViewController
      })
    }
    .height(CommonConstant.HEIGHT_FULL)
    .width(CommonConstant.WIDTH_FULL)
    .title($r('app.string.privacy_policy'))
    //最小化标题样式
    .titleMode(NavigationTitleMode.Mini)
    //栈式管理页面，按栈顺序逐层弹出
    .mode(NavigationMode.Stack)

    .padding({ top: this.topRectHeight })
  }
}