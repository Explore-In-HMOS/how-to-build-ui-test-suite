@Entry
@Component
struct Index {
  aboutToAppear() {
    console.info('testability/pages/Index.ets is about to appear.');
  }
  private title: string = 'Example Page';
  private subtitle: string = 'This is an example page where you can configure your custom tests with custom test pages in your testability/pages/Index.ets';

  build() {
    Column() {
      Text(this.title)
        .fontSize(36)
        .fontWeight(FontWeight.Bold)

      Text(this.subtitle)
        .fontSize(16)
        .fontWeight(FontWeight.Normal)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}