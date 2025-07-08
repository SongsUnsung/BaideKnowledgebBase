import { CommonConstant } from '../contants/CommonConstant';
import { router } from '@kit.ArkUI';
import { RouterConstant } from '../contants/RouterConstant';
import { showToast } from '../utils/Toast';
import userApi from '../api/UserApi';
import { PreferencesUtil } from '../utils/PreferencesUtil';

@Entry
@Component
struct LoginPage {
  // 多选框状态
  @State multiSelectStatus: boolean = false
  // 账号
  @State account: string = 'sbj'
  // 密码
  @State password: string = '123456'
  // 控制页面渐显动画
  @State pageOpacity: number = 0
  // 控制输入框缩放
  @State accountInputScale: number = 1
  @State passwordInputScale: number = 1

  aboutToAppear() {
    // 页面加载时执行渐显动画
    animateTo({
      duration: 500,
      curve: Curve.EaseOut
    }, () => {
      this.pageOpacity = 1
    })
  }

  /**
   * 登录
   */
  async login() {
    if (!this.multiSelectStatus) {
      showToast('请勾选用户协议和隐私政策')
      return
    }
    if (this.account === '' || this.password === '') {
      showToast('当前登录的账号密码不能为空')
      return
    }
    // 调用服务端登录
    const token = await userApi.userLogin({ account: this.account, password: this.password });
    // 如果token存在
    if (token) {
      AppStorage.setOrCreate(CommonConstant.TOKEN_NAME, token)
      PreferencesUtil.savaData(CommonConstant.PREFERENCES_NAME, CommonConstant.TOKEN_NAME, token)
      // 获取用户信息
      const userInfo = await userApi.getUserInfo();
      if (!userInfo) {
        showToast(CommonConstant.DEFAULT_LOGIN_ERROR)
        AppStorage.delete(CommonConstant.TOKEN_NAME);
        PreferencesUtil.removeData(CommonConstant.PREFERENCES_NAME, CommonConstant.TOKEN_NAME);
        return;
      }
      // 存放用户数据
      AppStorage.setOrCreate(CommonConstant.USER_INFO, userInfo)
      PreferencesUtil.savaData(CommonConstant.PREFERENCES_NAME, CommonConstant.USER_INFO, JSON.stringify(userInfo))
      // 登录成功
      showToast('登录成功')
      // 回到首页
      router.replaceUrl({
        url: RouterConstant.PAGE_INDEX, params: {
          "currentIndex": 0
        }
      })
    } else {
      showToast(CommonConstant.DEFAULT_LOGIN_ERROR)
    }
  }

  build() {
    Column() {
      Column({ space: 15 }) {
        Image($r('app.media.app_icon'))
          .width($r('app.float.common_width_big')).aspectRatio(1)
          .borderRadius(15)
        Text($r('app.string.application_name'))
          .fontSize($r('app.float.common_font_size_huge'))
          .fontWeight(FontWeight.Medium)
        Text($r('app.string.app_description'))
          .fontSize($r('app.float.common_font_size_small'))
          .fontColor($r('app.color.common_gray'))

        // 账号输入框
        TextInput({ placeholder: '请输入账号', text: this.account })
          .textInputStyles()
          .scale({ x: this.accountInputScale, y: this.accountInputScale })
          .onChange((value) => {
            this.account = value
          })
          .onFocus(() => {
            animateTo({
              duration: 200,
              curve: Curve.EaseOut
            }, () => {
              this.accountInputScale = 1.08 //缩放比例
            })
          })
          .onBlur(() => {
            animateTo({
              duration: 200,
              curve: Curve.EaseIn
            }, () => {
              this.accountInputScale = 1
            })
          })

        // 密码输入框
        TextInput({ placeholder: '请输入密码', text: this.password })
          .type(InputType.Password)
          .textInputStyles()
          .scale({ x: this.passwordInputScale, y: this.passwordInputScale })
          .onChange((value) => {
            this.password = value
          })
          .onFocus(() => {
            animateTo({
              duration: 200,
              curve: Curve.EaseOut
            }, () => {
              this.passwordInputScale = 1.08
            })
          })
          .onBlur(() => {
            animateTo({
              duration: 200,
              curve: Curve.EaseIn
            }, () => {
              this.passwordInputScale = 1
            })
          })

        // 用户协议和隐私协议
        Row() {
          Checkbox()
            .select($$this.multiSelectStatus)
            .width(16)
            .selectedColor("#FA6D1D")
          Text() {
            Span("已阅读并同意")
            Span(" 用户协议 ")
              .fontColor(Color.Black)
              .onClick(() => {
                router.pushUrl({ url: RouterConstant.PAGE_USER_POLICY })
              })
            Span("和")
            Span(" 隐私政策 ")
              .fontColor(Color.Black)
              .onClick(() => {
                router.pushUrl({ url: RouterConstant.PAGE_PRIVACY_POLICY })
              })
          }.fontSize($r('app.float.common_font_size_small'))
          .fontColor($r('app.color.common_gray'))
        }

        // 登录按钮
        Button('登录')
          .type(ButtonType.Normal)
          .width(200)
          .borderRadius(12)
          .onClick(() => {
            this.login()
          })

      }.height('60%')
    }
    .opacity(this.pageOpacity)
    .padding($r('app.float.common_padding'))
    .height(CommonConstant.HEIGHT_FULL)
    .width(CommonConstant.WIDTH_FULL)
    .justifyContent(FlexAlign.Center)
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize({ width: CommonConstant.WIDTH_FULL, height: CommonConstant.HEIGHT_FULL })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}

@Extend(TextInput)
function textInputStyles() {
  .placeholderFont({ size: 19 })
  .fontSize(15)
  .width(270)
  .borderRadius(14)
}