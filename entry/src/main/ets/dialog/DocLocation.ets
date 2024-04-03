import DocLocation from '../databaseability/rdb/entity/DocLocation';
import DocLocationTable from '../databaseability/rdb/model/DocLocation';

@CustomDialog
export default struct DocLocationDialog {
  controller: CustomDialogController;
  @State docLocationList: DocLocation[] = [];
  // 文档地址键对象
  @State docLocationKeyList: string[] = [];
  @Prop selectedDocLocationKey: string;
  @State selectedIndex: number = 0;
  @State selectedDocLocation: DocLocation = new DocLocation(-1, "", "");

  // 文档地址数据库对象
  private docLocationTable: DocLocationTable = new DocLocationTable();


  // 两个按钮的回调函数
  cancel: () => void;
  confirm: (selectedDocLocation: DocLocation) => void;



  aboutToAppear() {
    // 初始化文档地址数据库
    this.docLocationTable.getRdbStore(() => {
      this.docLocationTable.queryAll((result: DocLocation[]) => {
        this.docLocationList = result;
        this.docLocationList.forEach((docLocation: DocLocation, index: number) => {
          if (this.selectedDocLocationKey === "") {
            // 刚打开软件，没有选择文档地址
            this.selectedIndex = 0;
            this.selectedDocLocation = this.docLocationList[0];
          } else if (docLocation.getKey() === this.selectedDocLocationKey) {
            this.selectedIndex = index;
            this.selectedDocLocation = docLocation;
          }
          this.docLocationKeyList.push(docLocation.getKey());
        })
      });
    });
  }

  build() {
    Column() {
      Row() {
        Column() {
          Column() {
            Text('选择文档地址')
              .fontSize('24vp')
              .margin({ bottom: '20vp' })

            TextPicker({ range: this.docLocationKeyList, selected: this.selectedIndex })
              .height('200vp')
              .width('80%')
              .onChange((value: string, index: number) => {
                this.selectedIndex = index;
                this.selectedDocLocation = this.docLocationList[index];
              })
          }
          .alignItems(HorizontalAlign.Start)


          Text('创建并跳转到新地址')
          .width('100%')
          .textAlign(TextAlign.End)
          .fontColor(Color.Blue)
          .fontSize('12fp')
          .margin({ right: '50vp', bottom: '10vp' })
          .onClick(() => {
            this.controller.close();
            this.confirm(null);
            // this.createDocLocationDialog.open();
          })

          Column() {
            Row() {
              Button('取消')
                .backgroundColor(Color.Transparent)
                .fontColor("#000000")
                .width('50%')
                .height('100%')
                .onClick(() => {
                  this.controller.close();
                  this.cancel();
                })

              Divider().vertical(true)

              Button('确认')
                .backgroundColor(Color.Transparent)
                .fontColor("#000000")
                .width('50%')
                .height('100%')
                .onClick(() => {
                  this.controller.close();
                  this.confirm(this.selectedDocLocation);
                })

            }
            .width('100%')
          }
          .height('60vp')
          .padding({ bottom: '12vp' })
        }
        .width('100%').height('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: '24vp', right: '24vp', top: '12vp' })
      }
      .height('350vp')
    }
  }
}