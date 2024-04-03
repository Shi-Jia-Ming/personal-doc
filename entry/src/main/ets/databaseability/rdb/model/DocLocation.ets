import relationalStore from '@ohos.data.relationalStore';
import hilog from '@ohos.hilog';
import Database from '../Database'
import DocLocation from '../entity/DocLocation';

export default class DocLocationTable {
  // 表名
  private readonly TABLE_NAME: string = 'doc_location';
  // 表的字段
  private readonly COLUMNS: Array<string> = ['id', 'key', 'value'];
  // 数据库表的创建语句
  private readonly SQL_CREATE: string = `CREATE TABLE IF NOT EXISTS ${this.TABLE_NAME} (${this.COLUMNS[0]} INTEGER PRIMARY KEY AUTOINCREMENT, ${this.COLUMNS[1]} TEXT, ${this.COLUMNS[2]} TEXT)`;
  // 数据库变量
  private docLocationTable: Database = new Database(this.TABLE_NAME, this.SQL_CREATE, this.COLUMNS);

  /**
   * 构造函数
   *
   * @param callback 回调函数
   */
  constructor(callback: Function = () => {
  }) {
    this.docLocationTable.getRdbStore(callback);
  }

  /**
   * 获取数据库操作变量
   *
   * @param callback 回调函数
   */
  getRdbStore(callback: Function) {
    this.docLocationTable.getRdbStore(callback);
  }

  /**
   * 向数据库中插入数据
   *
   * @param docLocation 插入的数据对象
   * @param callback 回调函数
   */
  insertData(docLocation: DocLocation, callback: Function = () => {
  }) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(docLocation);
    this.docLocationTable.insertData(valueBucket, callback);
  }

  /**
   * 从数据库中删除一条数据
   *
   * @param docLocation 要删除的数据对象（按照id匹配）
   * @param callback 回调函数
   */
  deleteData(docLocation: DocLocation, callback: Function = () => {
  }) {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_NAME);
    predicates.equalTo(this.COLUMNS[0], docLocation.getId());
    this.docLocationTable.deleteData(predicates, callback);
  }

  /**
   * 更新数据库中的一条数据
   *
   * @param docLocation 新的数据（按照id匹配）
   * @param callback 回调函数
   */
  updateData(docLocation: DocLocation, callback: Function = () => {
  }) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(docLocation);
    const predicates = new relationalStore.RdbPredicates(this.TABLE_NAME);
    predicates.equalTo(this.COLUMNS[0], docLocation.getId());
    this.docLocationTable.updateData(predicates, valueBucket, callback);
  }

  /**
   * 从数据库中查询数据
   *
   * @param id 根据id查询数据
   * @param callback 回调函数
   */
  queryById(id: number, callback: Function = () => {
  }) {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_NAME);
    predicates.equalTo(this.COLUMNS[0], id);
    this.docLocationTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        hilog.info(0xF00, '[DocLocationTable]', `Query no result!`);
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: DocLocation[] = [];
        for (let i = 0; i < count; ++i) {
          const docLocation: DocLocation = new DocLocation(-1, "", "");
          docLocation.setId(resultSet.getDouble(resultSet.getColumnIndex(this.COLUMNS[0])));
          docLocation.setKey(resultSet.getString(resultSet.getColumnIndex(this.COLUMNS[1])));
          docLocation.setValue(resultSet.getString(resultSet.getColumnIndex(this.COLUMNS[2])));
          result[i] = docLocation;
          resultSet.goToNextRow();
        }
        callback(result);
      }
    })
  }
  /**
   * 从数据库中查询全部数据
   *
   * @param callback 回调函数
   */
  queryAll(callback: Function = () => {
  }) {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_NAME);
    predicates.notEqualTo(this.COLUMNS[0], -1);
    this.docLocationTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        hilog.info(0xF00, '[DocLocationTable]', `Query no result!`);
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: DocLocation[] = [];
        for (let i = 0; i < count; ++i) {
          const docLocation: DocLocation = new DocLocation(-1, "", "");
          docLocation.setId(resultSet.getDouble(resultSet.getColumnIndex(this.COLUMNS[0])));
          docLocation.setKey(resultSet.getString(resultSet.getColumnIndex(this.COLUMNS[1])));
          docLocation.setValue(resultSet.getString(resultSet.getColumnIndex(this.COLUMNS[2])));
          result[i] = docLocation;
          resultSet.goToNextRow();
        }
        callback(result);
      }
    })
  }
}

function generateBucket(docLocation: DocLocation): relationalStore.ValuesBucket {
  const bucket: relationalStore.ValuesBucket = {};
  bucket.key = docLocation.getKey();
  bucket.value = docLocation.getValue();
  return bucket;
}