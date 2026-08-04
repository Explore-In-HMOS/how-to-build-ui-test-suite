import { AnalyzerOption, getStatusColor } from '../common/AnalyzerOptions';

@Component
export struct Details {
  @State option: AnalyzerOption = {
    title: '',
    subtitle: '',
    currentScore: 0,
    lastUpdate: '',
    status: ''
  }

  @State pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column({ space: 8 }) {
        // Title block
        Text(this.option.title)
          .id('detailsTitleText')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .width('100%')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.option.subtitle)
          .id('detailsSubtitleText')
          .fontSize(12)
          .fontColor('#999999')
          .textAlign(TextAlign.Center)
          .width('100%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: 6 })

        // Big score row: pop | score | push
        Row() {
          Button() {
            Image($r('sys.media.ohos_ic_back'))
              .id('detailsBackIcon')
              .width(20)
              .height(20)
              .fillColor(Color.White)
          }
          .id('detailsBackButton')
          .type(ButtonType.Circle)
          .width(36)
          .height(36)
          .backgroundColor('#ff2b2b2b')
          .onClick(() => {
            this.pathStack.pop();
          })

          Text(`${this.option.currentScore}`)
            .id('detailsScoreLabel')
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .layoutWeight(1)

          Button() {
            Image($r('sys.media.ohos_ic_public_add'))
              .id('detailsAddIcon')
              .width(20)
              .height(20)
              .fillColor(Color.White)
          }
          .id('detailsAddButton')
          .type(ButtonType.Circle)
          .width(36)
          .height(36)
          .backgroundColor('#ff2b2b2b')
          .onClick(() => {
            this.pathStack.pushPathByName('Statics', this.option);
          })
        }
        .id('detailsScoreRow')
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)

        // Status pill
        Text(this.option.status)
          .id('detailsStatusPill')
          .fontSize(12)
          .fontColor(Color.White)
          .backgroundColor(getStatusColor(this.option.status))
          .borderRadius(10)
          .padding({ left: 10, right: 10, top: 3, bottom: 3 })
          .margin({ top: 2, bottom: 10 })

        // Last update
        Text(this.option.lastUpdate)
          .id('detailsLastUpdateText')
          .fontSize(11)
          .fontColor('#8E8E93')
          .textAlign(TextAlign.Center)
          .width('100%')
          .margin({ bottom: 4 })
      }
      .id('detailsColumn')
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .padding({
        left: 16,
        right: 16,
        top: 8
      })
    }
    .hideTitleBar(true)
    .hideBackButton(true)
    .onReady((ctx: NavDestinationContext) => {
      const param = ctx.pathInfo.param as AnalyzerOption;
      this.option = param;
      this.pathStack = ctx.pathStack;
    })
  }
}