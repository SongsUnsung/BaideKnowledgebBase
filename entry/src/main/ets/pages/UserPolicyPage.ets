import { webview } from '@kit.ArkWeb'
import { CommonConstant } from '../contants/CommonConstant'

@Entry
@Component
struct UserPolicyPage {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  webViewController: webview.WebviewController = new webview.WebviewController

  build() {
    Navigation() {
      Web({
        src: $rawfile("UserPolicy.html"),
        controller: this.webViewController
      })
    }
    .height(CommonConstant.HEIGHT_FULL)
    .width(CommonConstant.WIDTH_FULL)
    .title($r('app.string.user_policy'))
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .padding({ top: this.topRectHeight })
  }
}