import webview from '@ohos.web.webview'
import DocLocation from '../databaseability/rdb/entity/DocLocation';
import DocLocationTable from '../databaseability/rdb/model/DocLocation';
import ServerIP from '../databaseability/preferences/model/ServerIP';
import ServerIPDialog from '../dialog/SetServerIP';
import DocLocationDialog from '../dialog/DocLocation';
import CreateDocLocationDialog from '../dialog/CreateDocLocation';
import promptAction from '@ohos.promptAction';
import hilog from '@ohos.hilog';

@Entry
@Component
struct Index {
  // Web容器控制器
  webviewController: WebviewController = new webview.WebviewController();

  // 文档地址列表
  @State docLocationList: DocLocation[] = [];

  // 当前选中的文档地址
  @State @Watch("refresh") selectedDocLocation: DocLocation = new DocLocation(-1, "", "");

  // 当前的服务器ip
  @State serverIP: string = "";

  refresh() {
    if (this.serverIP !== "") {
      this.webviewController.loadUrl(`${this.serverIP}/${this.selectedDocLocation.getValue()}`);
    }
  }

  // 文档地址数据库对象
  private docLocationTable: DocLocationTable = new DocLocationTable();

  // 编辑服务器IP窗口
  serverIPDialog: CustomDialogController = new CustomDialogController({
    builder: ServerIPDialog({
      serverIP: this.serverIP,
      cancel: () => {},
      confirm: (serverIP: string) => {
        this.serverIP = serverIP;
        ServerIP.writePreference(ServerIP.SERVER_IP, serverIP);
      }
    })
  });

  // 编辑文档地址窗口
  docLocationDialog: CustomDialogController = new CustomDialogController({
    builder: DocLocationDialog({
      selectedDocLocationKey: this.selectedDocLocation.getKey(),
      cancel: () => {},
      confirm: (docLocation: DocLocation) => {
        if (docLocation !== null) {
          this.selectedDocLocation = docLocation;
        } else {
          this.createDocLocationDialog.open();
        }
      }
    })
  })

  // 创建文档地址的窗口
  createDocLocationDialog: CustomDialogController = new CustomDialogController({
    builder: CreateDocLocationDialog({
      cancel: () => {},
      confirm: (newDocLocation: DocLocation) => {
        this.docLocationTable.getRdbStore(() => {
          this.docLocationTable.insertData(newDocLocation, (id: number) => {
            newDocLocation.setId(id);
            this.selectedDocLocation = newDocLocation;
          })
        })
      }
    })
  })

  // 按钮的菜单栏
  @Builder BtnMenu() {
    Menu() {
      MenuItemGroup({ header: "当前配置" }) {
        MenuItem({ startIcon: $r('app.media.ic_public_storage'), content: "服务器IP", labelInfo: this.serverIP })
          .onClick(() => {
            this.serverIPDialog.open();
          })
        MenuItem({ startIcon: $r('app.media.ic_public_file'),content: "文档地址", labelInfo: this.selectedDocLocation.getKey() })
          .onClick(() => {
            this.docLocationDialog.open();
          })
      }
      MenuItemGroup({ header: "网页操作" }) {
        MenuItem({ startIcon: $r('app.media.ic_public_rotate'), content: "刷新界面" })
          .enabled(this.serverIP !== '')
          .onClick(() => {
            try {
              this.webviewController.loadUrl(`${this.serverIP}/${this.selectedDocLocation.getValue()}`);
              hilog.info(0xFF00, '[Webview]', `Load static resource finished!`);
            } catch (err) {
              hilog.error(0xFF00, '[Webview]', `Load static resource error, code: ${err.code}, msg: ${err.message}`);
            }
            promptAction.showToast({
              message: "网页刷新成功" + `${this.serverIP}/${this.selectedDocLocation.getValue()}`,
              duration: 300
            });
          })
      }
    }
  }

  async aboutToAppear() {
    // 初始化服务器ip数据库
    ServerIP.getPreferencesFromStorage();
    ServerIP.getPreference(ServerIP.SERVER_IP).then((value: string) => {
      this.serverIP = value;
    });

    // 初始化文档地址数据库
    this.docLocationTable.getRdbStore(() => {
      this.docLocationTable.queryAll((result: DocLocation[]) => {
        this.docLocationList = result;
      })
    });

    // 设置选中的文档地址
    if (this.docLocationList.length !== 0) {
      this.selectedDocLocation = this.docLocationList[0];
    }
  }

  build() {
    RelativeContainer() {
      if (this.serverIP === "") {
        Text('请输入服务器IP和要访问的文档路径！')
          .id('remind-msg')
      } else {
        Web({ src: `${this.serverIP}/${this.selectedDocLocation.getValue()}`, controller: this.webviewController })
          .id('web-container')
          .width('100%').height('100%')
      }

      Button() {
        Image($r('app.media.ic_public_settings'))
          .width('60%').height('60%')
          .fillColor(Color.White)
      }
      .width('55vp')
      .height('55vp')
      .type(ButtonType.Circle)
      .id('setting-btn')
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        middle: { anchor: '__container__', align: HorizontalAlign.End }
      })
      .offset({
        y: -50,
        x: -100
      })
      .bindMenu(this.BtnMenu())
    }
    .width('100%').height('100%')
  }
}