import { SubTargetVo, TargetInfoVo } from '../api/TargetInfoApi.type'
import { CommonConstant } from '../contants/CommonConstant'

@Component
export struct LearnTargetContentComponent {
  // 目标数据
  @Prop targetInfoVo: TargetInfoVo

  build() {
    Column() {
      Column() {
        Text(this.targetInfoVo.content)
          .fontSize($r('app.float.common_font_size_medium'))
          .fontWeight(FontWeight.Normal)
          .maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
        Row() {
          Text(this.targetInfoVo.status === '0' ? '未完成' : '已完成')
            .fontColor(this.targetInfoVo.status === '0' ? '#848484' : '#1698CE')
            .fontSize($r('app.float.common_font_size_tiny'))
          Text(this.targetInfoVo.time).fontColor($r('app.color.common_gray'))
            .fontSize($r('app.float.common_font_size_tiny'))
        }.width(CommonConstant.WIDTH_FULL).justifyContent(FlexAlign.SpaceBetween)
      }.width('90%').alignItems(HorizontalAlign.Start)
      .height(70)
      .justifyContent(FlexAlign.SpaceAround)

      if (this.targetInfoVo.subTargets && this.targetInfoVo.subTargets.length > 0) {
        Column() {
          ForEach(this.targetInfoVo.subTargets, (subItem: SubTargetVo) => {
            Row() {
              Text('• ')
                .fontSize(16)
              Text(subItem.content)
                .fontSize(16)
                .layoutWeight(1)
                .margin({ left: 5 })
            }
            .width('100%')
            .padding({ top: 8, bottom: 8, left: 15, right: 15 })
          })
        }
        .width('100%')
        .backgroundColor('#F9F9F9')
        .borderRadius(8)
        .margin({ top: 10 })
      }
    }
    .width(CommonConstant.WIDTH_FULL)
    .backgroundColor($r('app.color.common_white'))
    .borderRadius(10)
    .justifyContent(FlexAlign.Center)
  }
}