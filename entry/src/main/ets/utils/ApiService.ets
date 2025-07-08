import http from '@ohos.net.http';  //鸿蒙网络模块
import { Message } from '../models/Message';
import { Logger } from './Logger';  //日志文件

// const API_KEY = 'f9f70175272e7329'; // 替换为您的API密钥
const API_URL = 'https://chatglm.cn/chatglm/assistant-api/v1/stream_sync';
const API_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc1MTY4NTE5MiwianRpIjoiOTE5MDM0ZWQtYzU2My00NzQzLThkNTctMmEyYmNmYmIwZmE1IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6IkFQSV82NzU3YTlhY2MxZmYxYWQwYjJiMzJmMDVfOWU0ZjRjYjIiLCJuYmYiOjE3NTE2ODUxOTIsImV4cCI6MTc1MjU0OTE5MiwidWlkIjoiNjg2ODk0MzcyYjhiMDBhYjYwNTA0OWYyIiwidXBsYXRmb3JtIjoiIiwiYXBpX3JvbGUiOiJkZXZlbG9wZXIiLCJyb2xlcyI6WyJhdXRoZWRfdXNlciJdfQ.uZtl6tLCzadr5EoJWsT18n04Cs6dffFehPN6adLB5Qw"
interface RequestBody {
  assistant_id: string;
  prompt: string;
}

// 定义最内层类型
interface AntispamResult {
  censorTime: number;
  censorType: number;
  dataId: string;
  hitSource: number;
  isRelatedHit: boolean;
  label: number;
  labels: string[]; // 根据实际内容调整，示例中是空数组
  resultType: number;
  suggestion: number;
  taskId: string;
}

interface LanguageDetail {
  type: string;
}

interface LanguageResult {
  dataId: string;
  details: LanguageDetail[];
  taskId: string;
}

interface NeteaseTextResult {
  antispam: AntispamResult;
  language: LanguageResult;
}

interface NeteaseText {
  code: number;
  msg: string;
  result: NeteaseTextResult;
}

// 定义中间层类型
interface InputRiskDetails {
  biz_type: string;
  from_cache: boolean;
  netease_text: NeteaseText;
  requestId: string;
}

interface RiskDetails {
  biz_type: string;
  netease_text: NeteaseText;
  requestId: string;
}

interface UsageData {
  completion_tokens: number;
  prompt_tokens: number;
  total_tokens: number;
}

// 定义输出项类型
interface ContentItem {
  text: string;
  type: string;
}

interface MetaData {
  input_risk_details: InputRiskDetails;
  input_risk_level: string;
  risk_details: RiskDetails;
  risk_level: string;
  toolCallRecipient: string;
  usage: UsageData;
}

interface OutputItem {
  content: ContentItem[];
  created_at: string;
  id: string;
  logic_id: string;
  meta_data: MetaData;
  model: string;
  recipient: string;
  role: string;
  status: string;
}

// 定义结果类型
interface ApiResult {
  conversation_id: string;
  history_id: string;
  output: OutputItem[];
  status: string;
}

// 定义完整响应类型
interface ApiResponse {
  message: string;
  result: ApiResult;
  status: number;
}

//错误类型定义
interface ErrorDetail {
  code?: number | string;
  message?: string;
}

export class ApiService {
  static cancelRequest() {
    
    throw new Error('Method not implemented.');
  }
  static async sendMessage(message:string): Promise<string> {
    try {
      Logger.info(` 发送消息: ${message}`)
      // 构造请求体
      const requestBody: RequestBody= {
                assistant_id:"6868979d2b8b00ab605049fe",
                prompt:message
              };

      // 创建HTTP请求
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        API_URL,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${API_TOKEN}`
          },
          extraData: JSON.stringify(requestBody)
        }
      );

      // 解析响应
      const responseBody = response.result as string;

      if (response.responseCode === 200) {
        // 使用显式类型转换
        const apiResponse: ApiResponse = JSON.parse(responseBody) as ApiResponse;

        // 检查API状态
        if (apiResponse.status !== 0) {
          return `API错误: ${apiResponse.message}`;
        }

        // 提取回复内容
        return ApiService.extractResponseContent(apiResponse.result);
      } else {
        // 尝试解析错误信息
        try {
          const errorResponse: ApiResponse = JSON.parse(responseBody) as ApiResponse;

          Logger.error(`API错误: ${errorResponse.message}`);
          return errorResponse.message || `HTTP错误: ${response.responseCode}`;
        } catch (e) {
          return `请求失败: ${response.responseCode}`;
        }
      }
    } catch (error) {
      // 处理错误类型
      const err = error as ErrorDetail;
      if (err.code !== undefined || err.message !== undefined) {
        return `网络错误: ${err.message ?? '未知错误'} (代码: ${err.code ?? '无'})`;
      }
      return '未知网络错误';
    }

  }

  // 提取响应内容的辅助方法
  private static extractResponseContent(result: ApiResult): string {
    // 检查是否有输出
    if (!result.output || result.output.length === 0) {
      return '未收到有效回复';
    }

    // 获取第一条输出
    const firstOutput = result.output[0];

    // 检查内容是否存在
    if (!firstOutput.content || firstOutput.content.length === 0) {
      return '回复内容为空';
    }

    // 查找文本类型的内容
    const textContent = firstOutput.content.find(item => item.type === 'text');

    if (textContent) {
      return textContent.text;
    }

    // 如果没有文本内容，尝试组合所有内容
    const allTexts = firstOutput.content
      .filter(item => item.text) // 确保有text属性
      .map(item => item.text);

    if (allTexts.length > 0) {
      return allTexts.join('\n');
    }

    return '无法解析回复内容';
  }
}
