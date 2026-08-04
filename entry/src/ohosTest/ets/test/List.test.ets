import StaticsTest from './Statics.test'
import DetailsTest from './Details.test'
import IndexTest from './Index.test'
import testabilityPageTest from './TestabilityPage.test'

export default function testsuite() {
  IndexTest()
  DetailsTest()
  StaticsTest()
  testabilityPageTest()
}