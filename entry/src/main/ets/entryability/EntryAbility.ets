// import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
// import { hilog } from '@kit.PerformanceAnalysisKit';
// import { window } from '@kit.ArkUI';
// import { IBestInit } from "@ibestservices/ibest-ui"
// import { ApplicationCheckUtil } from '../utils/ApplicationCheckUtil';
// import { RouterConstant } from '../contants/RouterConstant';
//
// export default class EntryAbility extends UIAbility {
//   onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
//     hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
//   }
//
//   onDestroy(): void {
//     hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
//   }
//
//   onWindowStageCreate(windowStage: window.WindowStage): void {
//     // Main window is created, set main page for this ability
//     hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
//
//     windowStage.loadContent('pages/Advertising', (err) => {
//       if (err.code) {
//         hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
//         return;
//       }
//       // 初始化组件库
//       IBestInit(windowStage, this.context)
//       hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
//     });
//   }
//
//   onWindowStageDestroy(): void {
//     // Main window is destroyed, release UI related resources
//     hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
//   }
//
//   onForeground(): void {
//     // Ability has brought to foreground
//     hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
//   }
//
//   onBackground(): void {
//     // Ability has back to background
//     hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
//   }
//
//
// }


import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { KeyboardAvoidMode, window } from '@kit.ArkUI';
import { IBestInit } from "@ibestservices/ibest-ui"
import { ApplicationCheckUtil } from '../utils/ApplicationCheckUtil';
import { RouterConstant } from '../contants/RouterConstant';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'; // 添加权限控制模块
import WindowTools from '../utils/WindowTools';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  // 添加权限请求方法
  async requestPermissions() {
    try {
      const atManager = abilityAccessCtrl.createAtManager();
      // 请求麦克风权限（网络权限是system_grant，无需请求）
      await atManager.requestPermissionsFromUser(
        this.context,
        ['ohos.permission.MICROPHONE']
      );
      hilog.info(0x0000, 'testTag', 'Microphone permission requested');
    } catch (err) {
      hilog.error(0x0000, 'testTag', 'Permission request failed: %{public}s', JSON.stringify(err) ?? '');
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    WindowTools.getInstance().setWindowStage(windowStage.getMainWindowSync())
    // 请求必要权限
    this.requestPermissions();

    windowStage.loadContent('pages/Advertising', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      // 初始化组件库
      IBestInit(windowStage, this.context)
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');

    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');

    // 每次回到前台时检查权限状态
    this.requestPermissions();
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}