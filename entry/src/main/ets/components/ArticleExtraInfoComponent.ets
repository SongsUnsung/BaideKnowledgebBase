import { ArticleContentData } from '../api/ArticleContentApi.type'

@Component
export struct ArticleExtraInfoComponent {
  // 文章数据
  @Prop articleInfo: ArticleContentData

  build() {
    Column() {
      // 第一行：阅读、点赞、收藏和时间
      Flex({ wrap: FlexWrap.NoWrap, alignItems: ItemAlign.Center }) {
        // 阅读量
        Text((this.articleInfo.readCount || '0') + ' 阅读')
          .textStyles()

        // 分隔点
        Text('·')
          .textStyles()
          .margin({ left: 6, right: 6 })

        // 点赞量
        Text((this.articleInfo.likeCount || '0') + ' 点赞')
          .textStyles()

        // 分隔点
        Text('·')
          .textStyles()
          .margin({ left: 6, right: 6 })

        // 收藏量
        Text((this.articleInfo.collectCount || '0') + ' 收藏')
          .textStyles()

        // 分隔点
        Text('·')
          .textStyles()
          .margin({ left: 6, right: 6 })

        // 时间
        Text(this.articleInfo.time || '未知时间')
          .textStyles()
      }
      .width('100%')

      // 第二行：分类标签
      Flex({ wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center }) {
        // 内容分类标签
        if (this.articleInfo.contentCategory === '1') {
          Text('鸿蒙')
            .tagStyle('#F0F8FF', '#1E90FF')
        } else if (this.articleInfo.contentCategory === '2') {
          Text('Java')
            .tagStyle('#F0F8FF', '#1E90FF')
        } else if (this.articleInfo.contentCategory === '3') {
          Text('Web前端')
            .tagStyle('#F0F8FF', '#1E90FF')
        } else if (this.articleInfo.contentCategory === '4') {
          Text('运维')
            .tagStyle('#F0F8FF', '#1E90FF')
        } else {
          Text('未知类别')
            .tagStyle('#F0F8FF', '#1E90FF')
        }

        // 难度分类标签
        if (this.articleInfo.difficultyCategory === '1') {
          Text(this.articleInfo.platformCategory === '1' ? '基础知识' : '简单面试题')
            .tagStyle('#FFF0F5', '#FF69B4')
        } else if (this.articleInfo.difficultyCategory === '2') {
          Text(this.articleInfo.platformCategory === '1' ? '进阶知识' : '中等面试题')
            .tagStyle('#FFF0F5', '#FF69B4')
        } else if (this.articleInfo.difficultyCategory === '3') {
          Text(this.articleInfo.platformCategory === '1' ? '高级知识' : '困难面试题')
            .tagStyle('#FFF0F5', '#FF69B4')
        } else {
          Text('未知难度')
            .tagStyle('#FFF0F5', '#FF69B4')
        }
      }
      .width('100%')
      .margin({ top: 8 })
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
  }
}

// 基础文本样式
@Extend(Text)
function textStyles() {
  .fontColor('#999999')
  .fontSize(12)
}

// 标签样式
@Extend(Text)
function tagStyle(bgColor: string, textColor: string) {
  .fontSize(11)
  .fontColor(textColor)
  .backgroundColor(bgColor)
  .padding({ left: 8, right: 8, top: 3, bottom: 3 })
  .borderRadius(12)
  .margin({ right: 8, bottom: 4 })
  .fontWeight(FontWeight.Medium)
}