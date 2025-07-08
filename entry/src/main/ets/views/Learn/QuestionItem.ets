
import questionInfoApi from '../../api/QuestionApi'
import { questionType } from '../../api/QuestionApi'
import { Logger } from '../../utils/Logger'
import { CommonConstant } from '../../contants/CommonConstant'
import router from '@ohos.router';


interface  paramsType{
  contentCategory:string | number,
  pageTitle:string
}
@Entry
@Component
export struct QuestionItem {
  @State questionList: questionType[] = []
  @State currentAnswers: Record<number, string | string[]> = {}
  @State showResult: Record<number, boolean> = {}
  @State currentPage: number = 1
  @State correctAnswerShown: Record<number, boolean> = {} // 控制是否显示正确答案
  @State pageTitle:string = ''
  @State contentCategory:number | string = ''

  @StorageProp('topRectHeight') topRectHeight: number = 0;


  private itemsPerPage: number = 1
  private static readonly ANSWER_KEY_PREFIX = 'answer_'
  private static readonly RESULT_KEY_PREFIX = 'result_'
  private static readonly CORRECT_SHOWN_KEY_PREFIX = 'correct_shown_'
  // 保存答案（包含分类ID+页面标题+题目ID）
  private async saveToAppStorage(questionId: number | string) {
    const storageKey = `${QuestionItem.ANSWER_KEY_PREFIX}${this.contentCategory}_${this.pageTitle}_${questionId}`
    AppStorage.setOrCreate(storageKey, this.currentAnswers[questionId])
    const resultKey = `${QuestionItem.RESULT_KEY_PREFIX}${this.contentCategory}_${this.pageTitle}_${questionId}`
    AppStorage.setOrCreate(resultKey, this.showResult[questionId])
    const correctShownKey = `${QuestionItem.CORRECT_SHOWN_KEY_PREFIX}${this.contentCategory}_${this.pageTitle}_${questionId}`
    AppStorage.setOrCreate(correctShownKey, this.correctAnswerShown[questionId])
  }

  // 加载答案（使用相同的键规则）
  private async loadFromAppStorage(questionId: number | string) {
    const storageKey = `${QuestionItem.ANSWER_KEY_PREFIX}${this.contentCategory}_${this.pageTitle}_${questionId}`
    const answer = AppStorage.get<string | string[]>(storageKey)
    if (answer !== undefined) this.currentAnswers[questionId] = answer

    const resultKey = `${QuestionItem.RESULT_KEY_PREFIX}${this.contentCategory}_${this.pageTitle}_${questionId}`
    const result = AppStorage.get<boolean>(resultKey)
    if (result !== undefined) this.showResult[questionId] = result

    const correctShownKey = `${QuestionItem.CORRECT_SHOWN_KEY_PREFIX}${this.contentCategory}_${this.pageTitle}_${questionId}`
    const correctShown = AppStorage.get<boolean>(correctShownKey)
    if (correctShown !== undefined) this.correctAnswerShown[questionId] = correctShown
  }
  private isArrayEqual(arr1: string[] | number[], arr2: string[] | number[]): boolean {
    if (arr1.length !== arr2.length) {
      return false;
    }

    // 手动复制数组
    const sortedArr1: (string | number)[] = [];
    for (const item of arr1) {
      sortedArr1.push(item);
    }
    sortedArr1.sort();

    const sortedArr2: (string | number)[] = [];
    for (const item of arr2) {
      sortedArr2.push(item);
    }
    sortedArr2.sort();

    return sortedArr1.every((value, index) => value === sortedArr2[index]);
  }


  // 获取题型名称
  private getQuestionTypeName(type: string): string {
    switch (type) {
      case 'single_choice':
        return '【单选题】'
      case 'multiple_choice':
        return '【多选题】'
      case 'short_answer':
        return '【问答题】'
      default:
        return ''
    }
  }

  async getQuestions() {
    const params = router.getParams() as paramsType
    if(params && params.contentCategory){
      this.pageTitle = params.pageTitle
      this.contentCategory = params.contentCategory
        if(params.contentCategory === 1)
        {
          this.questionList = await questionInfoApi.getHmQuestions()
        }else if(params.contentCategory === 2){
          this.questionList = await questionInfoApi.getJvQuestions()
        }else if(params.contentCategory === 3){
          this.questionList = await questionInfoApi.getQdQuestions()
        }else if(params.contentCategory === 4){
          this.questionList = await questionInfoApi.getYwQuestions()
        }
    }

    Logger.info('questionList'+JSON.stringify(this.questionList))
  }

  async aboutToAppear() {

    await this.getQuestions()
    this.questionList.forEach(item => {
      this.loadFromAppStorage(item.id)
    })
  }

  build() {
    Navigation(){
      Column({ space: 20 }) {
        Divider()
          .strokeWidth(1)
          .color('#ddd')

        // 题目区域
        ForEach(this.questionList.slice((this.currentPage - 1) * this.itemsPerPage,
          this.currentPage * this.itemsPerPage), (item: questionType) => {
          Column({ space: 15 }) {
            // 题目内容
            Text(item.question)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)

            // 题型标识
            Text(this.getQuestionTypeName(item.type))
              .fontSize(14)
              .fontColor('#666')

            // 根据题型显示不同内容
            if (item.type === 'single_choice') {
              Column({ space: 10 }) {
                ForEach(item.options!, (option: string) => {
                  Row({ space: 10 }) {
                    Radio({ value: option, group: `radioGroup_${item.id}` })
                      .checked(this.currentAnswers[item.id] === option)
                      .onChange((isSelect: boolean) => {
                        if (isSelect) this.currentAnswers[item.id] = option
                      })
                    Text(option).fontSize(16)
                  }
                  .width('100%')
                  .padding(10)
                  .borderRadius(5)
                  .borderColor('#ddd')
                  .borderWidth(1)
                })
              }
            } else if (item.type === 'multiple_choice') {
              Column({ space: 10 }) {
                ForEach(item.options!, (option: string) => {
                  Row({ space: 10 }) {
                    Checkbox({ name: option})
                      .select((this.currentAnswers[item.id] as string[] || []).includes(option))
                      .onChange((isChecked: boolean) => {
                        let answers = [...(this.currentAnswers[item.id] as string[] || [])]
                        if (isChecked) {
                          answers.push(option)
                        } else {
                          answers = answers.filter(a => a !== option)
                        }
                        this.currentAnswers[item.id] = answers
                        Logger.info('mulAnswer: ' + JSON.stringify(answers))
                      })
                    Text(option).fontSize(16)
                  }
                  .width('100%')
                  .padding(10)
                  .borderRadius(5)
                  .borderColor('#ddd')
                  .borderWidth(1)
                })
              }
            } else if (item.type === 'short_answer') {
              TextInput({ placeholder: '请输入您的答案',text: this.currentAnswers[item.id] as string ?? '' })
                .onChange((value: string) => {
                  this.currentAnswers[item.id] = value
                })
                .width('100%')
                .height(120)
                .padding(10)
                .borderRadius(5)
                .borderColor('#ddd')
                .borderWidth(1)
            }

            // 提交按钮
            Button('提交答案')
              .onClick(() => {
                if(item.type === 'multiple_choice'){
                  const answer = item.answer as string[]
                  const userAnswer = this.currentAnswers[item.id] as string[] || []
                  Logger.info('answer111'+JSON.stringify(answer))
                  Logger.info('userAnswer111'+JSON.stringify(userAnswer))
                  // 判断是否相等（忽略顺序）
                  const isCorrect = this.isArrayEqual(answer, userAnswer)

                  this.showResult[item.id] = isCorrect
                  this.correctAnswerShown[item.id] = true
                  this.saveToAppStorage(item.id)
                }else{
                  const correctAnswer = JSON.stringify(item.answer)
                  const userAnswer = JSON.stringify(this.currentAnswers[item.id])
                  this.showResult[item.id] = correctAnswer === userAnswer
                  this.correctAnswerShown[item.id] = true
                  this.saveToAppStorage(item.id)
                }

              })
              .width('100%')
              .backgroundColor('#90eebf')
              .margin({ top: 10 })

            // 结果显示
            if (this.showResult[item.id] !== undefined) {
              Text(this.showResult[item.id] ? '回答正确 ✓' : '回答错误 ✗')
                .fontColor(this.showResult[item.id] ? '#07c160' : '#ff4d4f')
                .fontSize(16)
                .margin({ top: 5 })
            }
            if (this.correctAnswerShown[item.id]) {
              Text(`正确答案：${item.answer}`)
                .fontSize(16)
                .fontColor('#555')
                .margin({ top: 5 })
            }

          }
          .width('100%')
          .padding(15)
          .borderRadius(10)
          .borderColor('#eee')
          .borderWidth(1)
        })

        // 分页控制
        Row({ space: 20 }) {
          Button('上一题')
            .onClick(() => {
              if (this.currentPage > 1) this.currentPage--
            })
            .enabled(this.currentPage > 1)
            .backgroundColor('#90eebf')
            .flexGrow(1)

          Text(`${this.currentPage}/${this.questionList.length}`)
            .fontSize(16)

          Button('下一题')
            .onClick(() => {
              if (this.currentPage < this.questionList.length) this.currentPage++
            })
            .enabled(this.currentPage < this.questionList.length)
            .backgroundColor('#90eebf')
            .flexGrow(1)
        }
        .width('100%')
        .margin({ top: 10 })

        // 刷新按钮
        Button('刷新题目')
          .onClick(() => {
            this.getQuestions()
            this.currentPage = 1
            this.currentAnswers = {}
            this.showResult = {}
            this.correctAnswerShown = {}
          })
          .width('100%')
          .fontColor(Color.Black)
          .backgroundColor(Color.White)
          .borderColor('#90eebf')
          .borderWidth(1)
          .margin({ top: 10 })
      }
      .padding(20)
      .width('100%')
      .height('100%')
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
