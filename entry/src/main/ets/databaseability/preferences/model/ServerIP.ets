import hilog from '@ohos.hilog';
import { Preference } from '../Preferences';

class ServerIP extends Preference {
  /**
   * 数据库存储的字段名
   */
  readonly SERVER_IP: string = 'server_ip';

  /**
   * 以键值对的形式存储数据
   *
   * @param key 键
   * @param value 值
   * @returns
   */
  async putPreference(key: string, value: string | boolean | number): Promise<void> {
    if (~this.preference) {
      await this.getPreferencesFromStorage();
    }

    // 添加数据
    try {
      await this.preference.put(key, value);
    } catch (err) {
      hilog.info(0xFF00, '[DataPreference]', `Failed to put value, Cause: ${err}`);
    }
    await this.preference.flush();
  }

  /**
   * 通过键来获取值
   *
   * @param key 键
   * @returns 返回值
   */
  async getPreference(key: string): Promise<string | boolean | number | null> {
    let value = '';
    if (!this.preference) {
      await this.getPreferencesFromStorage();
    }
    // 获取数据
    try {
      value = (await this.preference.get(key, '')).toString();
    } catch (err) {
      hilog.info(0xFF00, '[DataPreference]', `Failed to get value, Cause: ${err}`);
    }
    // 如果值未空，则展示报错信息
    if (value === undefined) {
      this.writePreference(key, key === 'enableSayings' ? true : null);
      // this.showToastMessage('Data is empty, please write data first!');
      hilog.info(0xFF00, '[DataPreference]', 'Data is empty, please write data first!');
      return;
    }
    this.showToastMessage('Read data successfully!');
    return value;
  }

  /**
   * 检查键值对是否为空
   *
   * @param key   键
   * @param value 值
   * @returns 返回键值对是否为空
   */
  checkInfoData(key: string, value: string | number | boolean): boolean {
    if (key === '' || value === '' || value === null) {
      this.showToastMessage('Personal information is empty, please write data first!');
      return true;
    }
    return false;
  }

  /**
   * 向数据库中写入键值对
   *
   * @param key   键
   * @param value 值
   */
  writePreference(key: string, value: string | boolean | number) {
    if (this.checkInfoData(key, value)) {
      return;
    }
    this.putPreference(key, value);
    this.showToastMessage('Write data successfully!');
  }
}

export default new ServerIP('server_ip.db');