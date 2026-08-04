import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  AnalyzerOption,
  OPTIONS,
  getOptionCount,
  getOptionTitle,
  isValidOption,
  getStatusColor
} from '../../../entry/src/main/ets/common/AnalyzerOptions'

export default function AnalyzerOptionsTest() {
  describe('AnalyzerOptionsTest', () => {
    beforeAll(() => {
      // Runs once before all test cases in this suite.
    })
    beforeEach(() => {
      // Runs before every test case.
    })
    afterEach(() => {
      // Runs after every test case.
    })
    afterAll(() => {
      // Runs once after all test cases in this suite.
    })

    // ---------------------------------------------------------------------
    // OPTIONS data integrity
    // ---------------------------------------------------------------------

    it('options_shouldContainExactlyEightEntries', 0, () => {
      expect(OPTIONS.length).assertEqual(8)
    })

    it('options_everyEntryShouldHaveNonEmptyTitleAndSubtitle', 0, () => {
      let allValid: boolean = true
      for (let i = 0; i < OPTIONS.length; i++) {
        if (OPTIONS[i].title.length === 0 || OPTIONS[i].subtitle.length === 0) {
          allValid = false
        }
      }
      expect(allValid).assertTrue()
    })

    it('options_everyScoreShouldBeWithinZeroToHundredRange', 0, () => {
      let allInRange: boolean = true
      for (let i = 0; i < OPTIONS.length; i++) {
        let score: number = OPTIONS[i].currentScore
        if (score < 0 || score > 100) {
          allInRange = false
        }
      }
      expect(allInRange).assertTrue()
    })

    it('options_titlesShouldBeUnique', 0, () => {
      let titles: string[] = []
      for (let i = 0; i < OPTIONS.length; i++) {
        titles.push(OPTIONS[i].title)
      }
      let uniqueCount: number = new Set(titles).size
      expect(uniqueCount).assertEqual(OPTIONS.length)
    })

    it('options_firstEntryShouldBeShotAnalysis', 0, () => {
      expect(OPTIONS[0].title).assertEqual('Shot Analysis')
      expect(OPTIONS[0].status).assertEqual('Ready')
      expect(OPTIONS[0].currentScore).assertEqual(82)
    })

    it('options_lastEntryShouldBeGameReport', 0, () => {
      let lastIndex: number = OPTIONS.length - 1
      expect(OPTIONS[lastIndex].title).assertEqual('Game Report')
      expect(OPTIONS[lastIndex].status).assertEqual('Pending')
    })

    // ---------------------------------------------------------------------
    // getOptionCount
    // ---------------------------------------------------------------------

    it('getOptionCount_shouldReturnLengthOfOptionsArray', 0, () => {
      expect(getOptionCount()).assertEqual(OPTIONS.length)
    })

    it('getOptionCount_shouldReturnEight', 0, () => {
      expect(getOptionCount()).assertEqual(8)
    })

    // ---------------------------------------------------------------------
    // getOptionTitle
    // ---------------------------------------------------------------------

    it('getOptionTitle_shouldReturnCorrectTitleForFirstIndex', 0, () => {
      expect(getOptionTitle(0)).assertEqual('Shot Analysis')
    })

    it('getOptionTitle_shouldReturnCorrectTitleForMiddleIndex', 0, () => {
      expect(getOptionTitle(3)).assertEqual('Speed Analysis')
    })

    it('getOptionTitle_shouldReturnCorrectTitleForLastIndex', 0, () => {
      expect(getOptionTitle(OPTIONS.length - 1)).assertEqual('Game Report')
    })

    it('getOptionTitle_shouldReturnEmptyStringForNegativeIndex', 0, () => {
      expect(getOptionTitle(-1)).assertEqual('')
    })

    it('getOptionTitle_shouldReturnEmptyStringForIndexEqualToLength', 0, () => {
      expect(getOptionTitle(OPTIONS.length)).assertEqual('')
    })

    it('getOptionTitle_shouldReturnEmptyStringForIndexFarOutOfBounds', 0, () => {
      expect(getOptionTitle(999)).assertEqual('')
    })

    // ---------------------------------------------------------------------
    // isValidOption
    // ---------------------------------------------------------------------

    it('isValidOption_shouldReturnTrueForExistingOption', 0, () => {
      let existing: AnalyzerOption = OPTIONS[0]
      expect(isValidOption(existing)).assertTrue()
    })

    it('isValidOption_shouldReturnTrueForClonedOptionWithSameValues', 0, () => {
      let cloned: AnalyzerOption = {
        title: 'Jump Analysis',
        subtitle: 'Measures jump height, takeoff strength, landing balance, and explosiveness.',
        currentScore: 88,
        lastUpdate: 'Updated yesterday',
        status: 'Ready'
      }
      expect(isValidOption(cloned)).assertTrue()
    })

    it('isValidOption_shouldReturnFalseWhenTitleDiffers', 0, () => {
      let modified: AnalyzerOption = {
        title: 'Unknown Analysis',
        subtitle: OPTIONS[0].subtitle,
        currentScore: OPTIONS[0].currentScore,
        lastUpdate: OPTIONS[0].lastUpdate,
        status: OPTIONS[0].status
      }
      expect(isValidOption(modified)).assertFalse()
    })

    it('isValidOption_shouldReturnFalseWhenScoreDiffers', 0, () => {
      let modified: AnalyzerOption = {
        title: OPTIONS[0].title,
        subtitle: OPTIONS[0].subtitle,
        currentScore: OPTIONS[0].currentScore + 1,
        lastUpdate: OPTIONS[0].lastUpdate,
        status: OPTIONS[0].status
      }
      expect(isValidOption(modified)).assertFalse()
    })

    it('isValidOption_shouldReturnFalseWhenStatusDiffers', 0, () => {
      let modified: AnalyzerOption = {
        title: OPTIONS[0].title,
        subtitle: OPTIONS[0].subtitle,
        currentScore: OPTIONS[0].currentScore,
        lastUpdate: OPTIONS[0].lastUpdate,
        status: 'Bogus Status'
      }
      expect(isValidOption(modified)).assertFalse()
    })

    it('isValidOption_shouldReturnFalseWhenLastUpdateDiffers', 0, () => {
      let modified: AnalyzerOption = {
        title: OPTIONS[0].title,
        subtitle: OPTIONS[0].subtitle,
        currentScore: OPTIONS[0].currentScore,
        lastUpdate: 'Updated just now',
        status: OPTIONS[0].status
      }
      expect(isValidOption(modified)).assertFalse()
    })

    it('isValidOption_shouldReturnFalseForCompletelyFabricatedOption', 0, () => {
      let fake: AnalyzerOption = {
        title: 'Fake Analysis',
        subtitle: 'This does not exist.',
        currentScore: 0,
        lastUpdate: 'Never',
        status: 'Unknown'
      }
      expect(isValidOption(fake)).assertFalse()
    })

    // ---------------------------------------------------------------------
    // getStatusColor
    // ---------------------------------------------------------------------

    it('getStatusColor_shouldReturnGreenForReady', 0, () => {
      expect(getStatusColor('Ready')).assertEqual('#34C759')
    })

    it('getStatusColor_shouldReturnGreenForCompleted', 0, () => {
      expect(getStatusColor('Completed')).assertEqual('#34C759')
    })

    it('getStatusColor_shouldReturnBlueForInProgress', 0, () => {
      expect(getStatusColor('In Progress')).assertEqual('#0A84FF')
    })

    it('getStatusColor_shouldReturnOrangeForNeedsReview', 0, () => {
      expect(getStatusColor('Needs Review')).assertEqual('#FF9F0A')
    })

    it('getStatusColor_shouldReturnGrayForPending', 0, () => {
      expect(getStatusColor('Pending')).assertEqual('#8E8E93')
    })

    it('getStatusColor_shouldReturnGrayForUnknownStatus', 0, () => {
      expect(getStatusColor('Something Else')).assertEqual('#8E8E93')
    })

    it('getStatusColor_shouldBeCaseInsensitive', 0, () => {
      expect(getStatusColor('READY')).assertEqual('#34C759')
      expect(getStatusColor('completed')).assertEqual('#34C759')
      expect(getStatusColor('In PROGRESS')).assertEqual('#0A84FF')
      expect(getStatusColor('needs REVIEW')).assertEqual('#FF9F0A')
    })

    it('getStatusColor_shouldReturnGrayForEmptyString', 0, () => {
      expect(getStatusColor('')).assertEqual('#8E8E93')
    })

    // ---------------------------------------------------------------------
    // Cross-check: every real status in OPTIONS resolves to a valid color
    // ---------------------------------------------------------------------

    it('getStatusColor_shouldResolveEveryRealOptionStatusToAKnownColor', 0, () => {
      let knownColors: string[] = ['#34C759', '#0A84FF', '#FF9F0A', '#8E8E93']
      let allKnown: boolean = true
      for (let i = 0; i < OPTIONS.length; i++) {
        let color: string = getStatusColor(OPTIONS[i].status)
        if (knownColors.indexOf(color) === -1) {
          allKnown = false
        }
      }
      expect(allKnown).assertTrue()
    })
  })
}
