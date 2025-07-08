export class Message {   //创建消息对象
  id: string;          // 消息ID
  role: string;        // 角色：user/assistant
  content: string;     // 消息内容
  timestamp: number;   // 时间戳，用于记录消息排序

  constructor(role: string, content: string , id?:string) {
    this.id = id || Math.random().toString(36).substr(2, 9);
    this.role = role;
    this.content = content;
    this.timestamp = Date.now();
  }
}