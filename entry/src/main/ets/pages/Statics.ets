import { AnalyzerOption, getStatusColor } from '../common/AnalyzerOptions';
import { buildMetrics, buildTrend, Metric } from '../utils/Utils';
import { PromptAction } from '@kit.ArkUI';

@Component
export struct Statics {
  @State option: AnalyzerOption = {
    title: '',
    subtitle: '',
    currentScore: 0,
    lastUpdate: '',
    status: ''
  };

  @State pathStack: NavPathStack = new NavPathStack();
  @State metrics: Metric[] = [];
  @State trend: number[] = [];

  private promptAction: PromptAction = this.getUIContext().getPromptAction();

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 14 }) {
          // Score ring
          Stack({ alignContent: Alignment.Center }) {
            Progress({ value: this.option.currentScore, total: 100, type: ProgressType.Ring })
              .id('staticsScoreRing')
              .width(96)
              .height(96)
              .color(getStatusColor(this.option.status))
              .backgroundColor('#2A2A2A')
              .style({ strokeWidth: 8 })

            Column() {
              Text(`${this.option.currentScore}`)
                .id('staticsScore')
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
              Text('score')
                .id('staticsScoreCaption')
                .fontSize(10)
                .fontColor('#999999')
            }
            .id('staticsScoreColumn')
          }
          .id('staticsScoreStack')
          .margin({ top: 28 })

          Text(this.option.title)
            .id('staticsTitleText')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .width('100%')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(this.option.status)
            .id('staticsStatusPill')
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor(getStatusColor(this.option.status))
            .borderRadius(8)
            .padding({ left: 8, right: 8, top: 2, bottom: 2 })

          // Refresh action.
          Button('Refresh')
            .id('refreshButton')
            .fontSize(12)
            .height(32)
            .backgroundColor('#4C8DFF')
            .onClick(() => {
              this.metrics = buildMetrics(this.option);
              this.trend = buildTrend(this.option);
              try {
                this.promptAction.showToast({
                  message: 'Metrics refreshed',
                  duration: 1500
                });
              } catch (error) {
                console.info('Error with creating toast message!');
              }
            })

          // Metrics
          Column({ space: 8 }) {
            ForEach(this.metrics, (m: Metric) => {
              Column({ space: 2 }) {
                Row() {
                  Text(m.label)
                    .id(`staticsMetricLabel_${m.label}`)
                    .fontSize(11)
                    .fontColor('#CCCCCC')
                    .layoutWeight(1)
                  Text(`${m.value}`)
                    .id(`staticsMetricValue_${m.label}`)
                    .fontSize(11)
                    .fontColor('#FFFFFF')
                    .fontWeight(FontWeight.Medium)
                }
                .id(`staticsMetricRow_${m.label}`)
                .width('100%')

                Progress({ value: m.value, total: 100, type: ProgressType.Linear })
                  .id(`staticsMetricProgress_${m.label}`)
                  .width('100%')
                  .height(6)
                  .color('#4C8DFF')
                  .backgroundColor('#2A2A2A')
                  .style({ strokeWidth: 6 })
              }
              .id(`staticsMetricItem_${m.label}`)
              .width('100%')
            }, (m: Metric) => m.label)
          }
          .id('staticsMetricsColumn')
          .width('100%')
          .padding({ left: 20, right: 20 })

          // Trend sparkline
          Column({ space: 6 }) {
            Text('Last 7 sessions')
              .id('staticsTrendLabel')
              .fontSize(10)
              .fontColor('#999999')
              .width('100%')
              .textAlign(TextAlign.Start)

            Row({ space: 4 }) {
              ForEach(this.trend, (v: number) => {
                Column()
                  .width(10)
                  .height(Math.max(6, v * 0.4))
                  .borderRadius(3)
                  .backgroundColor('#4C8DFF')
                  .alignSelf(ItemAlign.End)
              }, (v: number) => `${v}`)
            }
            .id('staticsTrendRow')
            .width('100%')
            .height(42)
            .alignItems(VerticalAlign.Bottom)
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .id('staticsTrendColumn')
          .width('100%')
          .padding({ left: 20, right: 20 })

          Text(this.option.lastUpdate)
            .id('staticsLastUpdateText')
            .fontSize(10)
            .fontColor('#8E8E93')
            .margin({ top: 4, bottom: 16 })
        }
        .width('90%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .id('staticsScreenRoot')
      .scrollBar(BarState.Off)
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .hideBackButton(true)
    .onReady((ctx: NavDestinationContext) => {
      const param = ctx.pathInfo.param as AnalyzerOption;
      this.option = param;
      this.pathStack = ctx.pathStack;
      this.metrics = buildMetrics(param);
      this.trend = buildTrend(param);
    })
  }
}
