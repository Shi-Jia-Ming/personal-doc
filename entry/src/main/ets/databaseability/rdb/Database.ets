import relationalStore from '@ohos.data.relationalStore'
import hilog from '@ohos.hilog';


export default class Database {
  // 数据库配置
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'database.db',
    securityLevel: relationalStore.SecurityLevel.S1
  }
  // 数据库操作对象
  private rdbStore: relationalStore.RdbStore | null = null;
  // 数据库表名
  private tableName: string;
  // 数据库表创建脚本
  private sqlCreateScript: string;
  // 数据库字段名
  private columns: Array<string>;

  constructor(tableName: string, sqlCreateScript: string, columns: Array<string>) {
    this.tableName = tableName;
    this.sqlCreateScript = sqlCreateScript;
    this.columns = columns;
  }

  // 通过数据库名获取数据库操作对象
  getRdbStore(callback: Function = () => {
  }) {
    // 回调函数无效
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      hilog.error(0xFF00, '[RelationDatabase]', 'Function getRdbStore() has no callback!');
      return;
    }
    // 数据库操作对象存在
    if (this.rdbStore !== null) {
      hilog.info(0xFF00, '[RelationDatabase]', 'Object rdbStore exists.');
      callback();
      return;
    }

    let context: Context = getContext(this) as Context;
    relationalStore.getRdbStore(context, Database.STORE_CONFIG, (err, rdb) => {
      if (err) {
        hilog.error(0xFF00, '[RelationDatabase]', `Get rdbStore failed, err: ${JSON.stringify(err)}`);
        return;
      }
      this.rdbStore = rdb;
      this.createTable();
      hilog.info(0xFF00, '[RelationDatabase]', `Get rdbStore finished.`);
      callback();
    })
  }

  // 创建数据库表
  createTable() {
    this.rdbStore.executeSql(this.sqlCreateScript);
  }

  // 插入数据
  insertData(data: relationalStore.ValuesBucket, callback: Function = () => {
  }) {
    // 回调函数无效
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      hilog.error(0xFF00, '[RelationDatabase]', 'Function insertData() has no callback!');
      return;
    }

    let resFlag: boolean = false;
    const valueBucket: relationalStore.ValuesBucket = data;
    this.rdbStore.insert(this.tableName, valueBucket, (err, ret) => {
      if (err) {
        hilog.error(0xFF00, '[RelationDatabase]', `Insert data failed, err: ${err.code}`);
        // 插入失败，回调函数返回 false
        callback(resFlag);
        return;
      }
      hilog.info(0xFF00, '[RelationDatabase]', `Insert data finished, count: ${ret}`);
      // 插入成功，回调函数显示当前数据库数据数量
      callback(ret);
    })
  }

  // 删除数据
  deleteData(predicates: relationalStore.RdbPredicates, callback: Function = () => {
  }) {
    // 回调函数无效
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      hilog.error(0xFF00, '[RelationDatabase]', 'Function deleteData() has no callback!');
      return;
    }

    let resFlag: boolean = false;
    this.rdbStore.delete(predicates, (err, ret) => {
      if (err) {
        hilog.error(0xFF00, '[RelationDatabase]', `Delete data failed, err: ${err}`);
        // 删除失败，回调函数返回 false
        callback(resFlag);
        return;
      }
      hilog.info(0xFF00, '[RelationDatabase]', `Delete data finished, count: ${ret}`);
      // 删除成功，回调函数显示当前数据库数据数量
      callback(ret);
    })
  }

  // 更新数据
  updateData(predicates: relationalStore.RdbPredicates, data: relationalStore.ValuesBucket, callback: Function = () => {
  }) {
    // 回调函数无效
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      hilog.error(0xFF00, '[RelationDatabase]', 'Function updateData() has no callback!');
      return;
    }

    let resFlag: boolean = false;
    const valueBucket: relationalStore.ValuesBucket = data;
    this.rdbStore.update(valueBucket, predicates, (err, ret) => {
      if (err) {
        hilog.error(0xFF00, '[RelationDatabase]', `Update data failed, err: ${err}`);
        callback(resFlag);
        return;
      }
      hilog.info(0xFF00, '[RelationDatabase]', `Update data finished, count: ${ret}`);
      callback(ret);
    })
  }

  query(predicates: relationalStore.RdbPredicates, callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      hilog.error(0xFF00, '[RelationDatabase]', `query() has no callback!`);
      return;
    }
    if (this.rdbStore) {
      this.rdbStore.query(predicates, this.columns, (err, resultSet) => {
        if (err) {
          hilog.error(0xFF00, '[RelationDatabase]', `Query data failed, err: ${err}`);
          return;
        }
        hilog.info(0xFF00, '[RelationDatabase]', `Query finished!`);
        callback(resultSet);
        resultSet.close();
      })
    }
  }
}