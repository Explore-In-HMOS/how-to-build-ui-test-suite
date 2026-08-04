import { ArcList, ArcListItem } from '@ohos.arkui.ArcList';
import { AnalyzerOption, getStatusColor, OPTIONS } from '../common/AnalyzerOptions';
import { Details } from './Details';
import { Statics } from './Statics';

@Entry
@Component
struct Index {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack();

  @Builder
  pages(name: string) {
    if (name === 'Details') {
      Details();
    } else if (name === 'Statics') {
      Statics()
    }
  }

  build() {
    Navigation(this.pageStack) {
      ArcList({ initialIndex: 1 }) {
        ArcListItem() {
          Text('BasketAnalyze')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .width('100%')
            .maxLines(2)
            .margin({ bottom: 12 })
        }
        ForEach(OPTIONS, (item: AnalyzerOption) => {
          ArcListItem() {
            Column({ space: 4 }) {
              Text(item.title)
                .fontSize(15)
                .fontWeight(FontWeight.Medium)
                .textAlign(TextAlign.Center)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('100%')

              Row({ space: 6 }) {
                Circle({ width: 6, height: 6 })
                  .fill(getStatusColor(item.status))

                Text(`${item.currentScore}`)
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .justifyContent(FlexAlign.Center)
              .width('100%')
            }
            .id('optionButton')
            .width('90%')
            .height(48)
            .borderRadius(24)
            .backgroundColor('#ff2b2b2b')
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.pageStack.pushPathByName('Details', item);
            })
            .margin({ bottom: 6 })
          }
        }, (item: AnalyzerOption) => item.title)
      }
      .width('100%')
      .height('100%')
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.pages)
    .hideToolBar(true)
  }
}