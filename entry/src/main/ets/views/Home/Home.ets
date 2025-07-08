import { router } from '@kit.ArkUI'
import { RouterConstant } from '../../contants/RouterConstant'
import { CommonConstant } from '../../contants/CommonConstant'
import { ArticleComponent } from '../../components/ArticleComponent'
import articleContentApi from '../../api/ArticleContentApi'
import { LoadingComponent } from '../../components/LoadingComponent'
import { ArticleContentData } from '../../api/ArticleContentApi.type'
import { showToast } from '../../utils/Toast'

@Entry
@Component
export struct Home {
  @State newDividerShow: boolean = true
  @State hotDividerShow: boolean = false
  @State keyword: string = ''
  @State title: string = ''
  @State articleContentList: ArticleContentData[] = []
  @State total: number = 0
  @State page: number = 1
  @State pageSize: number = 7
  @State isShow: boolean = false
  @State isRefreshing: boolean = false
  isLoad: boolean = false
  @State textShow: boolean = false
  @State searchFocused: boolean = false
  @State listScrolling: boolean = false
  @State scrollOffset: number = 0

  @StorageProp('topRectHeight') topRectHeight: number = 0;

  async aboutToAppear() {
    this.getArticleNewDataList(true, false)
  }

  async getArticleNewDataList(isFlushed: boolean, isUpdate: boolean) {
    const articleDataList =
      await articleContentApi.getNewArticle({ page: this.page, pageSize: this.pageSize, title: this.title })
    isFlushed ? this.articleContentList = articleDataList.records :
    this.articleContentList.push(...articleDataList.records)
    this.total = articleDataList.total
    this.textShow = !(this.total > this.page * this.pageSize)
    this.isShow = true
    this.isLoad = false
    this.isRefreshing = false
    if (isUpdate) {
      showToast("已更新")
    }
  }

  async getArticleHotDataList(isFlushed: boolean, isUpdate: boolean) {
    const articleDataList =
      await articleContentApi.getHotArticle({ page: this.page, pageSize: this.pageSize, title: this.title })
    isFlushed ? this.articleContentList = articleDataList.records :
    this.articleContentList.push(...articleDataList.records)
    this.total = articleDataList.total
    this.textShow = !(this.total > this.page * this.pageSize)
    this.isShow = true
    this.isLoad = false
    this.isRefreshing = false
    if (isUpdate) {
      showToast("已更新")
    }
  }

  async getArticleDataList(isFlushed: boolean) {
    if (this.newDividerShow) {
      this.getArticleNewDataList(isFlushed, true)
    }
    if (this.hotDividerShow) {
      this.getArticleHotDataList(isFlushed, true)
    }
  }

  @Builder
  titleHeader() {
    Column() {
      Row({ space: 32 }) {
        Column() {
          Text($r('app.string.article_best_new'))
            .textStyles()
            .fontColor(this.newDividerShow ? '#1a1a1a' : '#666666')
            .fontWeight(this.newDividerShow ? FontWeight.Bold : FontWeight.Normal)
            .scale({ x: this.newDividerShow ? 1.05 : 1.0, y: this.newDividerShow ? 1.05 : 1.0 })
            .animation({
              duration: 300,
              curve: Curve.EaseInOut
            })

          if (this.newDividerShow) {
            Divider()
              .dividerStyles()
              .width(60)
              .animation({
                duration: 400,
                curve: Curve.EaseInOut
              })
          }
        }
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .borderRadius(12)
        .backgroundColor(this.newDividerShow ? 'rgba(0, 0, 0, 0.05)' : 'transparent')
        .onClick(() => {
          this.hotDividerShow = false
          this.newDividerShow = true
          this.isShow = false
          this.page = 1
          this.getArticleNewDataList(true, true)
        })
        .gesture(
          TapGesture()
            .onAction(() => {
              animateTo({
                duration: 150,
                curve: Curve.Sharp
              }, () => {})
            })
        )

        Column() {
          Text($r('app.string.article_best_hot'))
            .textStyles()
            .fontColor(this.hotDividerShow ? '#1a1a1a' : '#666666')
            .fontWeight(this.hotDividerShow ? FontWeight.Bold : FontWeight.Normal)
            .scale({ x: this.hotDividerShow ? 1.05 : 1.0, y: this.hotDividerShow ? 1.05 : 1.0 })
            .animation({
              duration: 300,
              curve: Curve.EaseInOut
            })

          if (this.hotDividerShow) {
            Divider()
              .dividerStyles()
              .width(60)
              .animation({
                duration: 400,
                curve: Curve.EaseInOut
              })
          }
        }
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .borderRadius(12)
        .backgroundColor(this.hotDividerShow ? 'rgba(0, 0, 0, 0.05)' : 'transparent')
        .onClick(() => {
          this.newDividerShow = false
          this.hotDividerShow = true
          this.isShow = false
          this.page = 1
          this.getArticleHotDataList(true, true)
        })
        .gesture(
          TapGesture()
            .onAction(() => {
              animateTo({
                duration: 150,
                curve: Curve.Sharp
              }, () => {})
            })
        )

      }
      .justifyContent(FlexAlign.Start)
      .width(CommonConstant.WIDTH_FULL)
      .padding({ left: 4, right: 4 })

      Divider()
        .color('rgba(0, 0, 0, 0.08)')
        .strokeWidth(0.5)
        .margin({ top: 16 })
    }
    .padding({ top: 16, bottom: 20 })
    .backdropBlur(20)
    .backgroundColor('rgba(255, 255, 255, 0.95)')
  }


  @Builder
  searchBar() {
    Column() {
      Row({ space: 12 }) {
        // 移除搜索图标，使用更现代的输入框设计
        Search({
          placeholder: '搜索感兴趣的内容...',
          value: $$this.keyword,
          icon: '' // 明确移除图标
        })
          .placeholderFont({ size: 15, weight: FontWeight.Normal })
          .placeholderColor('#999999')
          .textFont({ size: 15, weight: FontWeight.Medium })
          .backgroundColor('transparent')
          .border({ width: 0 })
          .padding({ left: 16 }) // 增加左侧内边距
          .onFocus(() => this.searchFocused = true)
          .onBlur(() => this.searchFocused = false)
          .onSubmit(() => {
            this.title = encodeURIComponent(this.keyword)
            this.isShow = false
            this.page = 1
            this.getArticleDataList(true)
          })
          .layoutWeight(1)

        if (this.keyword.length > 0) {
          Button({ type: ButtonType.Circle }) {
            Text("×")
              .fontSize(16)
              .fontColor('#CCCCCC')
              .fontWeight(FontWeight.Bold)
          }
          .width(24)
          .height(24)
          .backgroundColor('rgba(0, 0, 0, 0.08)')
          .margin({ right: 8 }) // 增加右侧外边距
          .onClick(() => {
            this.keyword = ''
            this.title = ''
            this.page = 1
            this.getArticleDataList(true)
          })
          .transition({ type: TransitionType.Insert, opacity: 0, scale: { x: 0.8, y: 0.8 } })
          .animation({ duration: 200, curve: Curve.EaseOut })
        }
      }
      .width(CommonConstant.WIDTH_FULL)
      .height(48)
      .backgroundColor(this.searchFocused ? 'rgba(0, 122, 255, 0.08)' : 'rgba(0, 0, 0, 0.04)')
      .borderRadius(24)
      .borderWidth(this.searchFocused ? 1.5 : 0)
      .borderColor(this.searchFocused ? '#007AFF' : 'transparent')
      .animation({ duration: 250, curve: Curve.EaseInOut })
      .shadow({
        radius: this.searchFocused ? 12 : 4,
        color: this.searchFocused ? 'rgba(0, 122, 255, 0.15)' : 'rgba(0, 0, 0, 0.08)',
        offsetX: 0,
        offsetY: this.searchFocused ? 4 : 2
      })
    }
    .padding({ left: 16, right: 16, top: 0, bottom: 12 })
  }

  @Builder
  articleListItem(item: ArticleContentData, index: number) {
    ListItem() {
      ArticleComponent({ articleContentData: item })
        .borderRadius(12) // 从 20 缩小为 12
        .backgroundColor('#FFFFFF')
        .shadow({
          radius: 4, // 从 12 缩小为 4
          color: 'rgba(0, 0, 0, 0.04)', // 更轻微的阴影
          offsetX: 0,
          offsetY: 2
        })
        .onClick(() => {
          router.pushUrl({
            url: RouterConstant.VIEWS_HOME_ARTICLE_INFO,
            params: { "articleId": item.id }
          })
        })
        .scale({ x: 0.96, y: 0.96 }) // 微缩
        .animation({ duration: 200, curve: Curve.EaseOut })
        .gesture(TapGesture().onAction(() => {
          animateTo({ duration: 100, curve: Curve.Sharp }, () => {})
        }))
    }
    .padding({ left: 16, right: 16, top: 2, bottom: 2 }) // 四边缩小间距
    .transition({ type: TransitionType.Insert, opacity: 0, translate: { y: 20 } })
    .animation({ duration: 300, delay: index * 40, curve: Curve.EaseOut })
  }

  @Builder
  bottomStatus() {
    if (this.textShow) {
      Column() {
        Text("✨")
          .fontSize(28)
          .opacity(0.6)
          .margin({ bottom: 8 })

        Text($r('app.string.no_have_article'))
          .fontColor('#999999')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .opacity(0.8)
      }
      .width(CommonConstant.WIDTH_FULL)
      .justifyContent(FlexAlign.Center)
      .padding({ top: 40, bottom: 40 })
      .transition({ type: TransitionType.Insert, opacity: 0 })
      .animation({ duration: 500, curve: Curve.EaseInOut })
    }
  }

  build() {
    Column() {
      // 标题栏
      this.titleHeader()

      // 搜索栏
      this.searchBar()

      if (this.isShow) {
        Refresh({
          refreshing: $$this.isRefreshing,
          offset: 64,
          friction: 62
        }) {
          List({ space: 4 }) { // 增加列表项间距
            ForEach(this.articleContentList, (item: ArticleContentData, index: number) => {
              this.articleListItem(item, index)
            })

            ListItem() {
              this.bottomStatus()
            }
          }
          .width(CommonConstant.WIDTH_FULL)
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .edgeEffect(EdgeEffect.Spring)
          .onScrollIndex(() => {
            this.listScrolling = true
            setTimeout(() => this.listScrolling = false, 150)
          })
          .onScroll((scrollOffset: number) => this.scrollOffset = scrollOffset)
          .onReachEnd(() => {
            if (!this.isLoad && this.total > this.page * this.pageSize) {
              this.isLoad = true
              this.page++
              this.newDividerShow ? this.getArticleNewDataList(false, false) : this.getArticleHotDataList(false, false)
            } else {
              this.textShow = true
            }
          })
        }
        .onRefreshing(() => {
          if (!this.isLoad) {
            this.isLoad = true
            this.textShow = false
            this.page = 1
            this.newDividerShow ? this.getArticleNewDataList(true, true) : this.getArticleHotDataList(true, true)
          }
        })
        .backgroundColor('transparent')
        .transition({ type: TransitionType.Insert, opacity: 0 })
        .animation({ duration: 600, curve: Curve.EaseOut })
      } else {
        Column() {
          LoadingComponent()
        }
        .width(CommonConstant.WIDTH_FULL)
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .transition({ type: TransitionType.Insert, opacity: 0 })
        .animation({ duration: 300, curve: Curve.EaseInOut })
      }
    }
    .width(CommonConstant.WIDTH_FULL)
    .height(CommonConstant.HEIGHT_FULL)
    .backgroundColor('#F8FAFD') // 更柔和的背景色
    .padding({ top: this.topRectHeight })
  }
}

@Extend(Text)
function textStyles() {
  .fontSize(18)
  .fontWeight(FontWeight.Medium)
  .letterSpacing(0.3)
}

@Extend(Divider)
function dividerStyles() {
  .color('#007AFF')
  .strokeWidth(3)
  .borderRadius(1.5)
  .shadow({
    radius: 4,
    color: 'rgba(0, 122, 255, 0.2)', // 更柔和的阴影
    offsetX: 0,
    offsetY: 2
  })
}