@CustomDialog
export default struct ServerIPDialog {
  // 自定义弹窗控制器
  controller: CustomDialogController;

  // 服务器地址
  @Prop serverIP: string;

  // 两个按钮的回调函数
  cancel: () => void;
  confirm: (serverIP: string) => void;

  build() {
    Row() {
      Column() {
        Column() {
          Text('编辑服务器IP')
            .fontSize('24vp')
            .margin({ bottom: '20vp' })
          TextInput({ placeholder: '', text: this.serverIP })
            .height('40vp')
            .onChange((value: string) => {
              this.serverIP = value;
            })
        }
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
                this.confirm(this.serverIP);
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
    .height('200vp')
  }
}