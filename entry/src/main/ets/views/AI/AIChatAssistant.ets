import { Message } from '../../models/Message';
import { ApiService } from '../../utils/ApiService';
import { window } from '@kit.ArkUI';
import WindowTools from '../../utils/WindowTools';

@Entry
@Component
export struct AIChatAssistant {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @State messages: Message[] = [
    new Message('assistant', '你好！我是AI助手，有什么可以帮您的吗？')
  ];
  @State inputText: string = '';
  @State isThinking: boolean = false;


  // 发送消息
  async sendMessage() {
    if (!this.inputText.trim()) {
      return;
    }

    // 添加用户消息
    const userMessage = new Message('user', this.inputText);
    this.messages = [...this.messages, userMessage];
    const currentInput = this.inputText;
    this.inputText = '';

    // 显示思考状态
    this.isThinking = true;

    try {
      // 发送请求并获取AI回复
      const aiResponse = await ApiService.sendMessage(currentInput);

      // 添加AI回复
      this.messages = [...this.messages, new Message('assistant', aiResponse)];
    } catch (error) {
      this.messages = [...this.messages, new Message('assistant', '处理您的请求时出错了，请稍后再试。')];
    } finally {
      this.isThinking = false;
    }
  }

  // 清空对话
  clearConversation() {
    this.messages = [new Message('assistant', '对话已清空，有什么可以帮您的吗？')];
  }

  aboutToAppear(): void {

    WindowTools.getInstance().registerOnWindowSizeChange()
  }

  build() {
    Column() {
      Column() {
        // 标题栏
        Row() {
          Image($r("app.media.icon_ai_pic"))
            .width(40)
            .height(40)
            .margin({ right: 8 })

          Text("Baide-AI")
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
          // .margin({ left: 16 })

          Button('清空对话')
            .type(ButtonType.Normal)
            .backgroundColor('#0262ad')
            .borderRadius(20)
            .width(100)
            .height(36)
            .fontColor(Color.White)
            .margin({ left: 'auto', right: 16 })
            .onClick(() => this.clearConversation())
        }
        .width('100%')
        .height(56)
        .padding({ left: 16 })
        .backgroundColor(Color.White)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Divider()
            .height(2)
            .linearGradient({
              angle: 90,
              colors: [
                [0x7FBCFB, 0.0],
                [0x0262ad, 0.5],
                [0x7FBCFB, 1.0]
              ]
            })
        }
        .width('100%')

      }
      .backgroundColor(Color.White)
      .height(56 + this.topRectHeight)
      .padding({ top: this.topRectHeight })
      .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
      .zIndex(99)


      // 消息列表
      List({ space: 10 }) {
        ForEach(this.messages, (message: Message) => {
          ListItem() {
            if (message.role === 'user') {
              // 用户消息 - 右侧显示
              Row() {
                Text(message.content)
                  .fontSize(15)
                  .padding(12)
                  .backgroundColor('#0262ad')
                  .borderRadius(20)
                  .fontColor(Color.White)
              }
              .justifyContent(FlexAlign.End)
              .width('100%')
              .margin({ top: 8, bottom: 8 })
            } else {
              // AI消息 - 左侧显示
              Row() {
                Text(message.content)
                  .fontSize(15)
                  .padding(12)
                  .backgroundColor('#e0e0e0')
                  .borderRadius(20)
                  .fontColor('#000')
              }
              .justifyContent(FlexAlign.Start)
              .width('100%')
              .margin({ top: 8, bottom: 8 })
            }
          }
        })
      }
      .layoutWeight(1) // 占据剩余空间
      .width('100%')
      .padding(16)
      .zIndex(1)

      // 底部输入区域
      Column() {
        // 思考状态指示器
        if (this.isThinking) {
          Row() {
            Text($r('app.string.thinking_text'))
              .margin({ left: 10 })
              .fontSize(16)
              .fontColor('#0262ad')

            Progress({ value: 0, total: 100, type: ProgressType.Ring })
              .width(30)
              .color('#0262ad')
              .style({ strokeWidth: 6, status: ProgressStatus.LOADING })
            
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 10 })
        }

        // 输入框和发送按钮
        Row() {
          TextInput({ text: this.inputText, placeholder: $r('app.string.input_hint') })
            .id('input1')
            .onChange((value: string) => {
              this.inputText = value;
            })
            .height(50)
            .layoutWeight(1)
            .type(InputType.Normal)
            .borderRadius(25)
            .padding({ left: 15, right: 15 })
            .backgroundColor('#fff')

          Button("发送")
            .width(80)
            .height(50)
            .type(ButtonType.Capsule)
            .backgroundColor('#0262ad')
            .fontColor('#fff')
            .margin({ left: 10 })

            .onClick(() => {
              this.sendMessage()
              this.getUIContext().getFocusController().clearFocus();
            }

          )
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
      }
      .padding(16)
      .backgroundColor('#f5f5f5')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff')
  }
}