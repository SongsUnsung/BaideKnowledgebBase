import http1 from '../request/Request1'
import { Logger } from '../utils/Logger'

export interface questionType{
  "id": string,
  "type":string ,
  "question": string,
  "options"?: string[]
  "answer": string | string[]
  'isCheck': boolean
}


class QuestionInfoApi {
  /**
   * 获取用户整体目标完成进度统计
   */
  getQdQuestions = ():Promise<questionType[]> => {
    return http1.get(`/QdQuestionList`)
  }
  getHmQuestions = ():Promise<questionType[]> => {
    return http1.get(`/HmQuestionList`)
  }
  getJvQuestions = ():Promise<questionType[]> => {
    return http1.get(`/JvQuestionList`)
  }
  getYwQuestions = ():Promise<questionType[]> => {
    return http1.get(`/YwQuestionList`)
  }

}

const questionInfoApi = new QuestionInfoApi();

export default questionInfoApi as QuestionInfoApi;