import { CommonConstant } from '../../contants/CommonConstant';
import { IBestDialog } from "@ibestservices/ibest-ui";
import userApi from '../../api/UserApi';
import { PreferencesUtil } from '../../utils/PreferencesUtil';
import { UserInfo } from '../../api/UserApi.type';
import { FileUtil } from '../../utils/FileUtil';
import { showToast } from '../../utils/Toast';
import { emitter, request } from '@kit.BasicServicesKit';
import { FileData } from '../../models/FileData';
import { common } from '@kit.AbilityKit';
import { Logger } from '../../utils/Logger';
import { ProgressDialog } from '../../components/ProgressDialog';

let context = getContext(this) as common.UIAbilityContext;

class TransitionConfig {
  type: TransitionType;
  opacity: number;
  duration: number;

  constructor(type: TransitionType, opacity: number, duration: number) {
    this.type = type;
    this.opacity = opacity;
    this.duration = duration;
  }
}

interface AnimationConfig {
  duration: number;
  curve: Curve;
  delay?: number;
}

class DialogCloseHandler {
  async handle(action: "cancel" | "confirm", component: MineInfo): Promise<boolean> {
    if (action === 'cancel') return true;

    const valueLength = component.inputNicknameValue.trim().length;
    component.formInputError = !valueLength;

    if (!component.formInputError) {
      await userApi.editNickname({ nickname: component.inputNicknameValue });
      showToast('更新用户昵称成功');
      const userInfo = await userApi.getUserInfo();
      component.userInfo = userInfo;
      AppStorage.setOrCreate(CommonConstant.USER_INFO, userInfo);
      PreferencesUtil.savaData(
        CommonConstant.PREFERENCES_NAME,
        CommonConstant.USER_INFO,
        JSON.stringify(userInfo)
      );
      return true;
    }
    return !component.formInputError;
  }
}

@Entry
@Component
struct MineInfo {
  @State inputNicknameValue: string = '';
  @State formInputError: boolean = false;
  @State dialogVisible: boolean = false;
  @State avatarOpacity: number = 0;
  @State nicknameOpacity: number = 0;
  @State avatarScale: number = 0.8;
  @State nicknameScale: number = 0.8;
  @StorageProp('topRectHeight') topRectHeight: number = 0;

  @StorageLink(CommonConstant.USER_INFO) userInfo: UserInfo = {
    nickname: '',
    account: '',
    avatarUri: '',
    id: 0
  };

  private readonly fadeInConfig: AnimationConfig = {
    duration: 300,
    curve: Curve.EaseOut
  };

  dialog: CustomDialogController = new CustomDialogController({
    builder: ProgressDialog({ message: `上传进度: 0%` }),
    customStyle: true,
    alignment: DialogAlignment.Center
  });

  private dialogCloseHandler = new DialogCloseHandler();

  aboutToAppear() {
    const userInfo = AppStorage.get<UserInfo>(CommonConstant.USER_INFO);
    if (userInfo?.account) {
      this.userInfo = userInfo;
    }

    setTimeout(() => {
      this.avatarOpacity = 1;
      this.avatarScale = 1;
    }, 200);

    setTimeout(() => {
      this.nicknameOpacity = 1;
      this.nicknameScale = 1;
    }, 300);
  }

  async editAvatar(): Promise<void> {
    try {
      const uri = await FileUtil.selectImage();
      if (!uri) {
        showToast("选择图片失败");
        return;
      }
      const fileData = FileUtil.convertFile(uri);
      const data = await FileUtil.copyUserFileToCache(uri, fileData);
      if (!data) {
        showToast("修改头像失败");
        return;
      }
      await this.uploadImage(fileData);
    } catch (error) {
      showToast("修改头像失败");
    }
  }

  async uploadImage(fileData: FileData): Promise<void> {
    let files: Array<request.File> = [{
      filename: fileData.fileFullName,
      name: 'file',
      uri: 'internal://cache/' + fileData.fileFullName,
      type: fileData.fileSuffix
    }];

    let uploadConfig: request.UploadConfig = {
      url: 'http://118.31.50.145:9003/v1/user/editAvatar',
      header: { "Authorization": AppStorage.get<string>("token") },
      method: 'POST',
      files: files,
      data: []
    };

    this.dialog.open();
    const response = await request.uploadFile(context, uploadConfig);

    response.on("progress", async (val, size) => {
      Logger.info("头像上传进度:", `${val / size * 100}%`);
      emitter.emit({ eventId: 100 }, { data: { process: `上传进度: ${(val / size * 100).toFixed(0)}%` } });
      if (val === size) {
        this.dialog.close();
        showToast('头像上传成功');
        const userInfo = await userApi.getUserInfo();
        this.userInfo = userInfo;
        AppStorage.setOrCreate(CommonConstant.USER_INFO, userInfo);
        PreferencesUtil.savaData(
          CommonConstant.PREFERENCES_NAME,
          CommonConstant.USER_INFO,
          JSON.stringify(userInfo)
        );
      }
    });
  }

  @Builder
  formInputContain() {
    Column() {
      TextInput({ placeholder: '请输入新的昵称,长度不能超过50字符', text: this.userInfo.nickname })
        .fontSize(14)
        .placeholderFont({ size: 14 })
        .onChange((value) => {
          this.inputNicknameValue = value;
          this.formInputError = false;
        });

      if (this.formInputError) {
        Text('昵称不能为空')
          .width(CommonConstant.WIDTH_FULL)
          .textAlign(TextAlign.Start)
          .margin({ top: 5, left: 5 })
          .fontColor(Color.Red)
          .fontSize($r('app.float.common_font_size_small'));
      }
    }
    .width('90%')
    .margin({ top: 15, bottom: 15 });
  }

  build() {
    Navigation() {
      Column() {
        // 头像区域
        Row() {
          Text('头像')
            .fontSize($r('app.float.common_font_size_medium'))
            .fontWeight(FontWeight.Medium);
          Row({ space: 10 }) {
            Image(this.userInfo.avatarUri)
              .width(30)
              .aspectRatio(1)
              .objectFit(ImageFit.Auto)
              .borderRadius(15);
            Image($r('app.media.icon_arrow'))
              .width(15)
              .aspectRatio(1);
          }
          .onClick(() => this.editAvatar());
        }
        .width(CommonConstant.WIDTH_FULL)
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor($r('app.color.common_white'))
        .height($r('app.float.common_height_small'))
        .padding(10)
        .borderRadius(5)
        .opacity(this.avatarOpacity)
        .scale({ x: this.avatarScale, y: this.avatarScale })
        .animation({
          duration: this.fadeInConfig.duration,
          curve: this.fadeInConfig.curve
        });

        Divider()
          .strokeWidth(1)
          .color('#ECECEC');

        // 昵称区域
        Row() {
          Text('昵称')
            .fontSize($r('app.float.common_font_size_medium'))
            .fontWeight(FontWeight.Medium);
          Row({ space: 10 }) {
            Text(this.userInfo.nickname.length > 10
              ? this.userInfo.nickname.substring(0, 10) + '...'
              : this.userInfo.nickname)
              .textStyles();
            Image($r('app.media.icon_arrow'))
              .width(15)
              .aspectRatio(1);
          }
          .onClick(() => this.dialogVisible = true);
        }
        .width(CommonConstant.WIDTH_FULL)
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor($r('app.color.common_white'))
        .height($r('app.float.common_height_small'))
        .padding(10)
        .borderRadius(5)
        .opacity(this.nicknameOpacity)
        .scale({ x: this.nicknameScale, y: this.nicknameScale })
        .animation({
          duration: this.fadeInConfig.duration,
          curve: this.fadeInConfig.curve,
          delay: 100
        });

        IBestDialog({
          visible: $dialogVisible,
          title: "修改用户昵称",
          showCancelButton: true,
          defaultBuilder: this.formInputContain.bind(this),
          beforeClose: (action) => this.dialogCloseHandler.handle(action, this)
        });
      }
      .width(CommonConstant.WIDTH_FULL)
      .padding($r('app.float.common_padding'))
    }
    .height(CommonConstant.HEIGHT_FULL)
    .width(CommonConstant.WIDTH_FULL)
    .title($r('app.string.mine_info_title'))
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .padding({ top: this.topRectHeight })
  }
}

@Extend(Text)
function textStyles() {
  .fontColor($r('app.color.common_gray'))
  .fontSize($r('app.float.common_font_size_small'))
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis });
}