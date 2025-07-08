import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { Logger } from '../utils/Logger';
import { showToast } from '../utils/Toast';
import { CommonConstant } from '../contants/CommonConstant';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { router } from '@kit.ArkUI';
import { RouterConstant } from '../contants/RouterConstant';


/**
 * axios封装
 */
const http1 = axios.create({
  baseURL: `http://81.71.4.164:3000`,
  headers: {
    'Content-Type': 'application/json',
  }
},)


/**
 * 添加请求拦截器
 */
http1.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // 账号：dlwu4
  // 密码：123456

  // 获取数据
  const token: string | undefined = "eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE3NTE1NDU5NDAsInVzZXJJZCI6MTkwMTUyNzAwNjA5MjEyNDE2Mn0.AXuJQxhDeyU5pbqhQskfMpStFjwOQLUiVOzFvk08r-tkTlrc5CC-dsNrFRT2MDupZ8mG8IGr2X843FIR6ZLmyA"
  // const token: string | undefined = AppStorage.get("token") || 'eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE3NTE0MzA5MDIsInVzZXJJZCI6MTkwMTUyNzAwNjA5MjEyNDE2Mn0.btMcrAd7VzxGNKSS3vrPE0-Ed-u_9eideTDr5XkStMD5zpjWtBbNP238QUtPCr9O0B7ggcFOb_mdh1C06YWGBw'
  // 获取token
  if (token) {
    config.headers.Authorization = token
  }
  return config;
}, (error: AxiosError) => {
  // 对请求错误做些什么
  return Promise.reject(error);
});


/**
 * 添加响应拦截器
 */
http1.interceptors.response.use((response: AxiosResponse) => {
  Logger.info("请求状态码" + JSON.stringify(response.data));
  return Promise.resolve(response.data);
}, (error: AxiosError) => {
  showToast('网络错误，换个网络试试');
  return Promise.reject(error);
});

export default http1;

/**
 * 清除用户信息并跳到登录页面
 */
async function clearLoginInfoAndGoLoginPage() {
  // 401错误  -> 清理用户信息，跳转到登录页
  // 清理token，返回登录页
  // userInfo有订阅者删不掉，所以重新赋值空的给userInfo
  AppStorage.setOrCreate(CommonConstant.USER_INFO, {
    nickname: '',
    account: '',
    avatarUri: '',
    id: 0
  })
  AppStorage.delete(CommonConstant.TOKEN_NAME)
  await PreferencesUtil.delAllData(CommonConstant.PREFERENCES_NAME, CommonConstant.TOKEN_NAME)
  await PreferencesUtil.delAllData(CommonConstant.PREFERENCES_NAME, CommonConstant.USER_INFO)
  // 跳转登录页面
  router.pushUrl({
    url: RouterConstant.PAGE_LOGIN
  })
}