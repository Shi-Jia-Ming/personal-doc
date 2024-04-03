import DocLocation from '../databaseability/rdb/entity/DocLocation';

@CustomDialog
export default struct  CreateDocLocationDialog {
  controller: CustomDialogController;

  @State keySet: string = "";
  @State valueSet: string = "";

  // 两个按钮的回调函数
  cancel: () => void;
  confirm: (newDocLocation: DocLocation) => void;

  build() {
    Row() {
      Column() {
        Column() {
          Text('新建文档地址')
            .fontSize('24vp')
            .margin({ bottom: '20vp' })
          TextInput({ placeholder: '输入文档标签', text: this.keySet })
            .height('40vp')
            .margin({ bottom: '20vp' })
            .onChange((value: string) => {
              this.keySet = value;
            })
          TextInput({ placeholder: '输入文档地址', text: this.valueSet })
            .height('40vp')
            .onChange((value: string) => {
              this.valueSet = value;
            })
        }
        .height('240vp')
        .alignItems(HorizontalAlign.Start)

        Column() {
          Row() {
            Button('取消')
              .backgroundColor(Color.Transparent)
              .fontColor("#000000")
              .width('50%')
              .onClick(() => {
                this.controller.close();
                this.cancel();
              })

            Divider().vertical(true)

            Button('确认')
              .backgroundColor(Color.Transparent)
              .fontColor("#000000")
              .width('50%')
              .onClick(() => {
                this.controller.close();
                const docLocation: DocLocation = new DocLocation(-1, this.keySet, this.valueSet);
                this.confirm(docLocation);
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
    .height('300vp')
  }
}