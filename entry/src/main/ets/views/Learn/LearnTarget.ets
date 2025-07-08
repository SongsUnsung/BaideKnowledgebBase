import { SplitLayout } from "@ohos.arkui.advanced.SplitLayout";
import targetInfoApi from '../../api/TargetInfoApi'
import { TargetInfoCountVo, TargetInfoVo } from '../../api/TargetInfoApi.type'
import { LearnTargetContentComponent } from '../../components/LearnTargetContentComponent'
import { LoadingComponent } from '../../components/LoadingComponent'
import { CommonConstant } from '../../contants/CommonConstant'
import { IBestDialog, IBestDialogUtil } from "@ibestservices/ibest-ui"
import { showToast } from '../../utils/Toast'
import { Router, router } from '@kit.ArkUI'
import { RouterConstant } from '../../contants/RouterConstant'


@Entry
@Component

export struct LearnTarget {
  //目标统计数据
  @State countData: TargetInfoCountVo = { totalQuantity: 0, completeQuantity: 0, updateTime: '' }
  //目标任务数
  @State targetInfoVos: TargetInfoVo[] = []
  //添加目标任务弹窗显示
  @State isShow: boolean = false
  @State total: number = 0
  // 当前页
  @State page: number = 1
  // 每一页大小
  @State pageSize: number = 10
  @State isRefreshing: boolean = false
  isLoad: boolean = false
  // 是否展示文本，列表到底
  @State textShow: boolean = false
  // 输入框目标里面的值
  @State inputTargetValue: string = ''
  @State formInputError: boolean = false
  @State dialogVisible: boolean = false
  //小目标
  // @State detailVisible: boolean = false
  // @State inputDetailValue: string = ''
  // @State detailInputError: boolean = false

  //获取当前主目标
  @State currentTargetId:number=0

  @StorageProp('topRectHeight') topRectHeight: number = 0;


  aboutToAppear() {
    this.getUserTargetData(true, false);
  }

  // 获取用户目标数据
  async getUserTargetData(isFlushed: boolean, isUpdate: boolean) {
    // 获取用户整体目标完成进度统计
    this.countData = await targetInfoApi.getTargetInfoCount();
    // 分页查询用户整体目标
    const pageResult = await targetInfoApi.pageListTargetInfo({ page: this.page, pageSize: this.pageSize });
    this.total = pageResult.total;

    // 判断总数据
    if (this.total > this.page * this.pageSize) {
      this.textShow = false;
    } else {
      this.textShow = true;
    }

    // 判断是否是刷新还是下拉
    if (isFlushed) {
      this.targetInfoVos = pageResult.records;
    } else {
      this.targetInfoVos.push(...pageResult.records);
    }

    // 并行加载每个目标的小目标列表
    // const subTargetPromises = this.targetInfoVos.map(item =>
    // targetInfoApi.listSubTargets({ targetId: item.id })
    // );
    // const subTargetsResults = await Promise.all(subTargetPromises);
    //
    // // 将小目标列表赋值给对应的主目标（避免使用对象展开运算符）
    // this.targetInfoVos = this.targetInfoVos.map((item, index) => {
    //   // 创建新的目标对象，显式复制所有属性
    //   const newItem: TargetInfoVo = {
    //     id: item.id,
    //     content: item.content,
    //     status: item.status,
    //     time: item.time,
    //     createTime: item.createTime,
    //     updateTime: item.updateTime,
    //     subTargets: subTargetsResults[index]  // 添加小目标列表
    //   };
    //   return newItem;
    // });

    // 展示页面数据
    this.isShow = true;
    // 节流，防止用户重复下拉
    this.isLoad = false;
    this.isRefreshing = false;
    // 是否刷新
    if (isUpdate) {
      showToast("已更新");
    }
  }


  build() {
    Navigation() {
      if(this.isShow){
      Column() {
        //整体进度
        Row() {
          Column() {
            Text('整体进度')
              .fontSize(22)
              .fontWeight(500)
              .margin({ top: 10, bottom: 10 })
            Text(this.countData.updateTime)
              .fontColor($r('app.color.common_gray'))
              .fontSize($r('app.float.common_font_size_tiny'))
          }
          .alignItems(HorizontalAlign.Start)
          .padding({ left: 10 })

          //进度
          Stack() {
            Progress({
              value: this.countData.completeQuantity,
              total: this.countData.totalQuantity,
              type: ProgressType.Ring
            })
              .style({ strokeWidth: 6 })
              .color('#1698CE')
              .width($r('app.float.common_width_medium'))
              .height($r('app.float.common_height_medium'))
            Text(this.countData.completeQuantity + '/' + this.countData.totalQuantity)
              .fontSize($r('app.float.common_font_size_tiny'))
              .offset({ x: -22 })
          }
          .layoutWeight(1)
          .alignContent(Alignment.End)
          .padding({ right: 20 })
        }
        .width('100%')
        .height(120)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .backgroundColor($r('app.color.background_color_gray'))

      Divider()
        .color($r('app.color.common_white'))
        .strokeWidth(3)
      //子目标
      Row() {
        Text('子目标')
          .fontSize($r('app.float.common_font_size_big'))
          .fontWeight(500)
          .fontColor('#191919')

        Image($r('app.media.icon_add'))
          .width(30)
          .aspectRatio(1)
          .onClick(() => {
            this.dialogVisible = true
          })
      }
      .width('100%')
      .padding($r('app.float.common_padding'))
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor($r('app.color.background_color_gray'))

      //添加目标对话框弹窗
      IBestDialog({
        visible: $dialogVisible,
        title: "添加目标",
        showCancelButton: true,
        defaultBuilder: (): void => this.formInputContain(),
        beforeClose: async (action) => {
          if (action === 'cancel') {
            return true
          }
          const valueLength = this.inputTargetValue.trim().length;
          this.formInputError = !valueLength;
          if (!this.formInputError) {
            // 添加新目标
            await targetInfoApi.addTargetInfo({ content: this.inputTargetValue })
            showToast('添加目标成功')
            // 查询数据
            this.page = 1
            this.aboutToAppear()
            return true
          }
          return !this.formInputError
        }
      })

      //Edit
      // IBestDialog({
      //   visible: $detailVisible,
      //   title: "目标详情",
      //   showCancelButton: true,
      //   defaultBuilder: (): void => this.detailInputContain(),
      //   beforeClose:async(action)=>{
      //     if (action === 'cancel') {
      //       return true
      //     }
      //     const valueLength1 = this.inputDetailValue.trim().length;
      //     this.detailInputError = !valueLength1;
      //     if (!this.detailInputError) {
      //       // 添加新目标
      //       await targetInfoApi.addSubTarget({
      //         targetId: this.currentTargetId,
      //         content: this.inputDetailValue
      //       })
      //
      //       showToast("添加小目标成功")
      //       // 刷新当前目标的小目标列表
      //       const newSubTargets = await targetInfoApi.listSubTargets({
      //         targetId: this.currentTargetId
      //       })
      //
      //       // 更新状态
      //       this.targetInfoVos = this.targetInfoVos.map(item => {
      //         if (item.id === this.currentTargetId) {
      //           // 显式创建新对象而不是使用展开运算符
      //           const updatedItem: TargetInfoVo = {
      //             id: item.id,
      //             content: item.content,
      //             status: item.status,
      //             time: item.time,
      //             createTime: item.createTime,
      //             updateTime: item.updateTime,
      //             subTargets: newSubTargets
      //           };
      //           return updatedItem;
      //         }
      //         return item;
      //       })
      //
      //       // 清空输入框
      //       this.inputDetailValue = ''
      //       return true
      //     }
      //     return !this.detailInputError
      //   }
      //
      // })

      Refresh({ refreshing: $$this.isRefreshing }) {
        Column() {
          // 目标内容
          List({ space: 15 }) {
            ForEach(this.targetInfoVos, (item: TargetInfoVo) => {
              ListItem() {
                LearnTargetContentComponent({
                  targetInfoVo: item
                })
              }.swipeAction({
                end: {
                  // index为该ListItem在List中的索引值。
                  builder: () => {
                    this.itemEnd(item)
                  },
                }
              }) // 设置侧滑属性.
            })
            if (this.textShow) {
              ListItem() {
                Text($r('app.string.no_have_article'))
                  .fontColor($r('app.color.common_gray'))
                  .fontSize($r('app.float.common_font_size_small'))
                  .width(CommonConstant.WIDTH_FULL)
                  .textAlign(TextAlign.Center)
                  .margin({ top: 20 })
              }
            }
          }
          .scrollBar(BarState.Off)
          .onReachEnd(() => {
            if (!this.isLoad) {
              if (this.total > this.page * this.pageSize) {
                this.isLoad = true
                this.page++
                this.getUserTargetData(false, false)
              } else {
                this.textShow = true
              }

            }
          })
        }.padding($r('app.float.common_padding'))
        .height('80%')
        .width(CommonConstant.WIDTH_FULL)
      }
      .onRefreshing(() => {
        if (!this.isLoad) {
          this.isLoad = true
          this.textShow = false
          // 页面恢复到1
          this.page = 1
          // 查询数据
          this.getUserTargetData(true, true)
        }
      })

      }

    }
    .height(CommonConstant.HEIGHT_FULL)
    .width(CommonConstant.WIDTH_FULL)
    .title($r('app.string.learn_target_title'))
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('app.color.background_color_gray'))
    .padding({ top: this.topRectHeight })
  }

  @Builder
  itemEnd(item: TargetInfoVo) {
    Row() {
      // 构建尾端滑出完成组件
      Button({ type: ButtonType.Circle }) {
        Image($r('app.media.icon_finish'))
          .width(40)
          .aspectRatio(1)
      }
      .onClick(async () => {
        // 完成未完成的目标
        if (item.status === '1') {
          showToast('当前目标已完成，无需重复点击')
          return
        }
        // 完成目标
        await targetInfoApi.completeTargetInfo({ id: item.id })
        showToast('目标已完成')
        router.replaceUrl({ url: RouterConstant.VIEWS_LEARN_TARGET })
      }).margin({ right: 10 })

      // 尾端滑出删除组件
      Button({ type: ButtonType.Circle }) {
        Image($r('app.media.icon_delete'))
          .width(40)
          .aspectRatio(1)
      }
      .margin({ right: 10 })
      .onClick(() => {
        IBestDialogUtil.open({
          title: "提示",
          message: "是否确认删除当前目标？",
          showCancelButton: true,
          onConfirm: () => {
            // 删除目标
            targetInfoApi.deleteTargetInfo({ id: item.id }).then(() => {
              showToast('删除目标成功')
              // router.replaceUrl({ url: RouterConstant.VIEWS_LEARN_TARGET })
              this.page = 1
              this.getUserTargetData(true, true)
            })

          }
        })
      })

      //子目标细化
      // Button({ type: ButtonType.Circle }) {
      //   Image($r('app.media.icon_add'))
      //     .width(40)
      //     .aspectRatio(1)
      //     .backgroundColor($r('app.color.common_white'))
      //     .onClick(() => {
      //       this.detailVisible = true
      //       this.currentTargetId = item.id
      //       this.inputDetailValue = ''
      //       })
      // }
    }.justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  formInputContain() {
    Column() {
      TextInput({ 'placeholder': '请输入目标内容,长度不能超过255字符' })
        .fontSize(14)
        .placeholderFont({ size: 14 })
        .onChange((value) => {
          this.inputTargetValue = value;
          this.formInputError = false
        })
      if (this.formInputError) {
        Text('目标内容不能为空')
          .width(CommonConstant.WIDTH_FULL)
          .textAlign(TextAlign.Start)
          .margin({
            top: 5,
            left: 5
          })
          .fontColor(Color.Red)
          .fontSize($r('app.float.common_font_size_small'))
          .transition({ type: TransitionType.Insert, opacity: 1 })
          .transition({ type: TransitionType.Delete, opacity: 0 })
      }

    }.width('90%').margin({ top: 15, bottom: 15 })
  }

  // @Builder
  // detailInputContain() {
  //   Column() {
  //     TextInput({ 'placeholder': '请输入小目标内容,长度不能超过255字符' })
  //       .fontSize(14)
  //       .placeholderFont({ size: 14 })
  //       .onChange((value) => {
  //         this.inputDetailValue = value;
  //         this.detailInputError = false
  //       })
  //     if(this.detailInputError){
  //       Text('小目标内容不能为空')
  //         .width(CommonConstant.WIDTH_FULL)
  //         .textAlign(TextAlign.Start)
  //         .margin({
  //           top: 5,
  //           left: 5
  //         })
  //         .fontColor(Color.Red)
  //         .fontSize($r('app.float.common_font_size_small'))
  //         .transition({ type: TransitionType.Insert, opacity: 1 })
  //         .transition({ type: TransitionType.Delete, opacity: 0 })
  //     }
  //   }.width('90%').margin({ top: 15, bottom: 15 })
  //
  // }
}