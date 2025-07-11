import { CommonConstant } from '../../contants/CommonConstant'
import { router } from '@kit.ArkUI'
import { RouterConstant } from '../../contants/RouterConstant'
import { showToast } from '../../utils/Toast'
import { ArticleContentData } from '../../api/ArticleContentApi.type'
import { ArticleComponent } from '../../components/ArticleComponent'

import articleContentApi from '../../api/ArticleContentApi'
import { Logger } from '../../utils/Logger'

@Entry
@Component
struct LearnContent {
  // 页面标题
  @State pageTitle: string = ''
  // 文章数据数组
  @State articleContentList: ArticleContentData[] = []
  // 是否展示全部标题的下划线
  @State allDividerShow: boolean = true
  // 是否展示基础标题的下划线
  @State basicDividerShow: boolean = false
  // 是否展示进阶标题的下划线
  @State advancedDividerShow: boolean = false
  // 是否展示高级标题的下划线
  @State seniorDividerShow: boolean = false
  // 搜索词
  @State keyword: string = ''
  // 文章总记录数
  @State total: number = 0
  // 当前页
  @State page: number = 1
  // 每一页大小
  @State pageSize: number = 7
  // 控制当前页面展示
  @State isShow: boolean = false
  // 定义一个状态属性，用来和Refresh组件进行双向数据绑定
  @State isRefreshing: boolean = false
  // 节流, false表示未请求, true表示正在请求
  isLoad: boolean = false
  // 是否展示文本，列表到底
  @State textShow: boolean = false
  // 当前文章分类id
  @State contentCategory: string = ''
  // 标题
  @State title: string = ''
  // 文章难度分类
  @State difficultyCategory: string = ''
  @State isFocused: boolean = false;

  @StorageProp('topRectHeight') topRectHeight: number = 0;

  /**
   * 生命周期
   */
  aboutToAppear() {
    // 获取路由传递的文章内容分类
    const param = router.getParams() as object
    if (param) {
      this.contentCategory = param["contentCategory"] as string
      this.pageTitle = param["pageTitle"] as string
      // 根据文章内容分类查询文章数据
      this.getArticleList(true, false)
    }
  }

  /**
   * 获取文章分类数据
   * @param isFlushed
   * @param isUpdate
   */
  async getArticleList(isFlushed: boolean, isUpdate: boolean) {
    // 判断当前文章难度分类
    if (this.allDividerShow) {
      this.difficultyCategory = ''
    } else if (this.basicDividerShow) {
      this.difficultyCategory = '1'
    } else if (this.advancedDividerShow) {
      this.difficultyCategory = '2'
    } else if (this.seniorDividerShow) {
      this.difficultyCategory = '3'
    } else {
      showToast('文章难度分类错误')
      return
    }
    // 获取文章分类数据
    const articleDataList = await articleContentApi.pageListArticleContent({
      page: this.page,
      pageSize: this.pageSize,
      title: this.title,
      contentCategory: this.contentCategory,
      platformCategory: '1',
      difficultyCategory: this.difficultyCategory
    })
    isFlushed ? this.articleContentList = articleDataList.records :
    this.articleContentList.push(...articleDataList.records)
    this.total = articleDataList.total
    // 判断总数据
    if (this.total > this.page * this.pageSize) {
      this.textShow = false
    } else {
      this.textShow = true
    }
    // 页面展示
    this.isShow = true
    // 节流，防止用户重复下拉
    this.isLoad = false
    this.isRefreshing = false
    // 是否刷新
    if (isUpdate) {
      showToast("已更新")
    }
  }

  build() {

    Navigation() {
      Column() {
        // 搜索
          Search({ placeholder: '请输入关键字', value: $$this.keyword })
            .placeholderFont({ size: 14 })
            .textFont({ size: 14 })
            .onSubmit(() => {
              this.title = encodeURIComponent(this.keyword)
              this.isShow = false
              this.page = 1
              this.getArticleList(true, true)
            })
            .onFocus(() => { this.isFocused = true; })
            .onBlur(() => { this.isFocused = false; })
            .backgroundColor(this.isFocused?'#F0F6FF' : '#ffffff')
            .border({
              width: 1,
              color: this.isFocused ? '#1890FF' : '#DDDDDD', // 边框色动态切换
              radius:15 // 圆角
            })
            .width(CommonConstant.WIDTH_FULL)
            .height(30)
            .margin({ bottom: 13 })



        // 条件刷选
        Row({ space: 10 }) {
          Column() {
            Text($r('app.string.all_condition'))
              .textStyles()
            // 选中标题会出现下划线
            if (this.allDividerShow) {
              Divider().dividerStyles()
            }
          }
          .onClick(() => {
            // 展示下划线
            this.basicDividerShow = false
            this.advancedDividerShow = false
            this.seniorDividerShow = false
            this.allDividerShow = true
            // 查询最新文章数据
            this.isShow = false
            this.page = 1
            this.getArticleList(true, true)
          })

          Column() {
            Text($r('app.string.basic_condition'))
              .textStyles()
            // 选中标题会出现下划线
            if (this.basicDividerShow) {
              Divider().dividerStyles()
            }
          }
          .onClick(() => {
            this.advancedDividerShow = false
            this.seniorDividerShow = false
            this.allDividerShow = false
            this.basicDividerShow = true
            // 查询最新文章数据
            this.isShow = false
            this.page = 1
            this.getArticleList(true, true)
          })

          Column() {
            Text($r('app.string.advance_condition'))
              .textStyles()
            // 选中标题会出现下划线
            if (this.advancedDividerShow) {
              Divider().dividerStyles()
            }
          }
          .onClick(() => {
            // 展示下划线
            this.seniorDividerShow = false
            this.allDividerShow = false
            this.basicDividerShow = false
            this.advancedDividerShow = true
            // 查询最新文章数据
            this.isShow = false
            this.page = 1
            this.getArticleList(true, true)
          })

          Column() {
            Text($r('app.string.senior_condition'))
              .textStyles()
            // 选中标题会出现下划线
            if (this.seniorDividerShow) {
              Divider().dividerStyles()
            }
          }
          .onClick(() => {
            // 展示下划线
            this.allDividerShow = false
            this.basicDividerShow = false
            this.advancedDividerShow = false
            this.seniorDividerShow = true
            // 查询最新文章数据
            this.isShow = false
            this.page = 1
            this.getArticleList(true, true)
          })

        }.justifyContent(FlexAlign.Start)
        .width(CommonConstant.WIDTH_FULL)

        // 内容组件
        if (this.isShow) {
          Refresh({ refreshing: $$this.isRefreshing }) {
            List() {
              ForEach(this.articleContentList, (item: ArticleContentData) => {
                ListItem() {
                  ArticleComponent({ articleContentData: item })
                    .onClick(() => {
                      Logger.info('文章跳转')
                      // 路由到内容详情页
                      router.pushUrl({
                        url: RouterConstant.VIEWS_HOME_ARTICLE_INFO, params: {
                          "articleId": item.id
                        }
                      })
                    })
                }
              })

            }
            .width(CommonConstant.WIDTH_FULL)
            .height(CommonConstant.HEIGHT_FULL)
            .scrollBar(BarState.Off)
            .onReachEnd(() => {
              if (!this.isLoad)
              {
                if (this.total > this.page * this.pageSize) {
                  this.isLoad = true
                  this.page++
                  // 分页查询文章数据
                  this.getArticleList(false, false)
                } else {
                  this.textShow = true
                }

              }
            })
          }.onRefreshing(() => {
            if (!this.isLoad) {
              this.isLoad = true
              this.textShow = false
              // 页面恢复到1
              this.page = 1
              this.getArticleList(true, true)
            }
          })
        } else {

        }
      }.padding($r('app.float.common_padding'))
    }
    .height(CommonConstant.HEIGHT_FULL)
    .width(CommonConstant.WIDTH_FULL)
    .title(this.pageTitle)
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('app.color.background_color_gray'))
    .padding({ top: this.topRectHeight })
  }
}

@Extend(Text)
function textStyles() {
  .fontSize($r('app.float.common_font_size_medium'))
  .fontWeight(FontWeight.Medium)
}

@Extend(Divider)
function dividerStyles() {
  .color(Color.Black)
  .width($r('app.float.common_width_tiny'))
  .strokeWidth(3)
}
