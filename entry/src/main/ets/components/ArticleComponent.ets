import { ArticleContentData } from '../api/ArticleContentApi.type'
import { CommonConstant } from '../contants/CommonConstant'

@Component
export struct ArticleComponent {
  // 文章数据
  @Prop articleContentData: ArticleContentData

  build() {
    Column() {
      // 用户信息行
      Row({ space: 12 }) {
        // 头像 - 改为圆形
        if (this.articleContentData.avatarUri && this.articleContentData.avatarUri.length > 0) {
          Image(this.articleContentData.avatarUri)
            .width(32)
            .height(32)
            .borderRadius(16)
            .objectFit(ImageFit.Cover)
        } else {
          // 默认头像占位
          Column() {
            Image($r('app.media.icon_bottom_my_selected'))
              .width(24)
              .height(24)
          }
          .width(32)
          .height(32)
          .borderRadius(16)
          .backgroundColor('#F5F5F5')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }

        // 姓名
        Text(this.articleContentData.nickname || '匿名用户')
          .fontSize(14)
          .fontColor('#666666')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1) // 占据剩余空间
      }
      .width('100%')
      .height(40)
      .alignItems(VerticalAlign.Center)

      // 标题和封面区域
      Row() {
        // 内容标题 - 增加行高和字体粗细
        Text(this.articleContentData.title || '无标题')
          .fontSize(16)
          .fontColor('#333333')
          .fontWeight(500)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(22)
          .layoutWeight(1) // 占据剩余空间

        // 封面图 - 增加圆角和阴影
        if (this.articleContentData.coverUrl && this.articleContentData.coverUrl.length > 0) {
          Image(this.articleContentData.coverUrl)
            .width(72)
            .height(72)
            .objectFit(ImageFit.Cover)
            .borderRadius(6)
            .shadow({ radius: 2, color: '#10000000', offsetX: 1, offsetY: 1 })
        } else {
          // 默认封面占位
          Column() {
            Image($r('app.media.icon_bottom_my_selected'))
              .width(24)
              .height(24)
          }
          .width(72)
          .height(72)
          .borderRadius(6)
          .backgroundColor('#F8F8F8')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .shadow({ radius: 2, color: '#10000000', offsetX: 1, offsetY: 1 })
        }
      }
      .width('100%')
      .height(80)
      .margin({ top: 4, bottom: 8 })
      .justifyContent(FlexAlign.SpaceBetween)

      // 元数据行 - 使用Flex布局允许换行
      Flex({ wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center }) {
        // 阅读量
        Text((this.articleContentData.readCount || '0') + ' 阅读')
          .textStyles()

        // 分隔点
        Text('·')
          .textStyles()
          .margin({ left: 6, right: 6 })

        // 时间
        Text(this.articleContentData.time || '未知时间')
          .textStyles()

        // 分隔点
        Text('·')
          .textStyles()
          .margin({ left: 6, right: 6 })

        // 内容分类标签
        if (this.articleContentData.contentCategory === '1') {
          Text('鸿蒙')
            .tagStyle('#F0F8FF', '#1E90FF')
        } else if (this.articleContentData.contentCategory === '2') {
          Text('Java')
            .tagStyle('#F0F8FF', '#1E90FF')
        } else if (this.articleContentData.contentCategory === '3') {
          Text('Web前端')
            .tagStyle('#F0F8FF', '#1E90FF')
        } else if (this.articleContentData.contentCategory === '4') {
          Text('运维')
            .tagStyle('#F0F8FF', '#1E90FF')
        } else {
          Text('未知类别')
            .tagStyle('#F0F8FF', '#1E90FF')
        }

        // 分隔点
        Text('·')
          .textStyles()
          .margin({ left: 6, right: 6 })

        // 难度分类标签
        if (this.articleContentData.difficultyCategory === '1') {
          Text(this.articleContentData.platformCategory === '1' ? '基础知识' : '简单面试题')
            .tagStyle('#FFF0F5', '#FF69B4')
        } else if (this.articleContentData.difficultyCategory === '2') {
          Text(this.articleContentData.platformCategory === '1' ? '进阶知识' : '中等面试题')
            .tagStyle('#FFF0F5', '#FF69B4')
        } else if (this.articleContentData.difficultyCategory === '3') {
          Text(this.articleContentData.platformCategory === '1' ? '高级知识' : '困难面试题')
            .tagStyle('#FFF0F5', '#FF69B4')
        } else {
          Text('未知难度')
            .tagStyle('#FFF0F5', '#FF69B4')
        }
      }
      .width('100%')
    }
    .padding(16)
    .width('100%')
    .margin({ top: 12, bottom: 4 })
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({ radius: 8, color: '#08000000', offsetX: 0, offsetY: 2 })
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