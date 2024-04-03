import dataPreferences from '@ohos.data.preferences';
import hilog from '@ohos.hilog';
import promptAction from '@ohos.promptAction';


/**
 * 用户首选项模型
 */
export class Preference {

  // 数据库文件名
  protected readonly FILE_NAME: string;

  // 数据库对象
  protected preference: dataPreferences.Preferences;
  protected preferenceTemp: dataPreferences.Preferences;

  // 应用上下文
  protected readonly context: Context;

  // 构造函数
  constructor(fileName: string) {
    this.FILE_NAME = fileName;
    this.context = getContext(this);
  }

  /**
   * 通过读取文件获取首选项数据
   */
  async getPreferencesFromStorage() {
    try {
      this.preference = await dataPreferences.getPreferences(this.context, this.FILE_NAME);
    } catch (err) {
      hilog.info(0xFF00, '[DataPreference]', `Failed to get preferences, Cause: ${err}`);
    }
  }

  /**
   * 将首选项数据库从存储中删除
   */
  async deletePreferencesFromStorage() {
    try {
      await dataPreferences.deletePreferences(this.context, this.FILE_NAME);
    } catch (err) {
      hilog.info(0xFF00, '[DataPreference]', `Failed to delete preferences, Cause: ${err}`);
    }
    this.preference = this.preferenceTemp;
    this.showToastMessage('Delete preferences successfully!');
  }

  // 展示信息
  showToastMessage(message: Resource | string) {
    promptAction.showToast({
      message: message,
      duration: 300
    });
  }
}