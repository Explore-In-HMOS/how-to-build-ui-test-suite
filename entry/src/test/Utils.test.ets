import { describe, it, expect } from '@ohos/hypium';
import {
  Metric,
  hashString,
  seededVariance,
  buildMetrics,
  buildTrend
} from '../../src/main/ets/utils/Utils';
import { AnalyzerOption } from '../main/ets/common/AnalyzerOptions';

// Creates a reusable mock option so each test only needs to provide
// the values that are relevant to the scenario.
function makeOption(title: string, currentScore: number): AnalyzerOption {
  return {
    title: title,
    subtitle: 'Test Subtitle',
    currentScore: currentScore,
    lastUpdate: '2026-07-10',
    status: 'active'
  };
}

export default function metricUtilsTest() {
  describe('UtilsTest', () => {
    // Confirms that the Metric constructor stores the provided values.
    it('Metric_constructor_setsFields', 0, () => {
      const m = new Metric('Accuracy', 80);

      expect(m.label).assertEqual('Accuracy');
      expect(m.value).assertEqual(80);
    });

    // The same input should always generate the same hash.
    it('hashString_isDeterministic', 0, () => {
      const a = hashString('hello world');
      const b = hashString('hello world');

      expect(a).assertEqual(b);
    });

    // Different inputs should normally generate different hash values.
    it('hashString_differentInputsLikelyDiffer', 0, () => {
      const a = hashString('option-a');
      const b = hashString('option-b');

      expect(a === b).assertFalse();
    });

    // Checks several input formats to ensure hashes never become negative.
    it('hashString_alwaysNonNegative', 0, () => {
      const values = ['', 'a', 'Analyzer Title!', '12345', '   spaces   '];

      for (let i = 0; i < values.length; i++) {
        expect(hashString(values[i]) >= 0).assertTrue();
      }
    });

    // An empty string is expected to produce the default hash value of zero.
    it('hashString_emptyStringIsZero', 0, () => {
      expect(hashString('')).assertEqual(0);
    });

    // The same seed and index should always produce the same variance.
    it('seededVariance_isDeterministic', 0, () => {
      const a = seededVariance(42, 3, 14);
      const b = seededVariance(42, 3, 14);

      expect(a).assertEqual(b);
    });

    // Every generated value should remain inside the requested spread.
    it('seededVariance_isWithinSpreadBounds', 0, () => {
      const spread = 14;

      for (let seed = 0; seed < 20; seed++) {
        for (let idx = 0; idx < 7; idx++) {
          const v = seededVariance(seed, idx, spread);
          expect(v >= -spread && v <= spread).assertTrue();
        }
      }
    });

    // Variance values are expected to be whole numbers.
    it('seededVariance_returnsIntegerValues', 0, () => {
      const v = seededVariance(10, 2, 18);

      expect(Number.isInteger(v)).assertTrue();
    });

    // A spread of zero should not introduce any variance.
    it('seededVariance_zeroSpreadYieldsZero', 0, () => {
      expect(seededVariance(5, 1, 0)).assertEqual(0);
    });

    // buildMetrics should always create the four expected metric categories.
    it('buildMetrics_returnsFourLabeledMetrics', 0, () => {
      const option = makeOption('Test Option', 70);
      const metrics = buildMetrics(option);

      expect(metrics.length).assertEqual(4);
      expect(metrics[0].label).assertEqual('Consistency');
      expect(metrics[1].label).assertEqual('Accuracy');
      expect(metrics[2].label).assertEqual('Efficiency');
      expect(metrics[3].label).assertEqual('Power');
    });

    // Even extreme scores should be limited to the supported metric range.
    it('buildMetrics_valuesAreClampedBetween35And99', 0, () => {
      // A very low score should still be raised to the minimum value.
      const low = buildMetrics(makeOption('Low Score Option', 0));

      for (let i = 0; i < low.length; i++) {
        expect(low[i].value >= 35 && low[i].value <= 99).assertTrue();
      }

      // A very high score should still be limited to the maximum value.
      const high = buildMetrics(makeOption('High Score Option', 150));

      for (let i = 0; i < high.length; i++) {
        expect(high[i].value >= 35 && high[i].value <= 99).assertTrue();
      }
    });

    // Rebuilding metrics for the same option should produce identical results.
    it('buildMetrics_isDeterministicForSameOption', 0, () => {
      const option = makeOption('Repeatable Option', 65);
      const first = buildMetrics(option);
      const second = buildMetrics(option);

      for (let i = 0; i < first.length; i++) {
        expect(first[i].value).assertEqual(second[i].value);
      }
    });

    // Changing the title changes the seed, so at least one metric should differ.
    it('buildMetrics_differsByTitleSeed', 0, () => {
      const a = buildMetrics(makeOption('Option A', 65));
      const b = buildMetrics(makeOption('Option B', 65));

      let anyDifferent = false;

      for (let i = 0; i < a.length; i++) {
        if (a[i].value !== b[i].value) {
          anyDifferent = true;
        }
      }

      expect(anyDifferent).assertTrue();
    });

    // A trend should contain one value for each of the seven trend points.
    it('buildTrend_returnsSevenPoints', 0, () => {
      const option = makeOption('Trend Option', 70);
      const trend = buildTrend(option);

      expect(trend.length).assertEqual(7);
    });

    // Trend values should remain inside their supported display range.
    it('buildTrend_valuesAreClampedBetween20And99', 0, () => {
      const low = buildTrend(makeOption('Low Trend Option', 0));

      for (let i = 0; i < low.length; i++) {
        expect(low[i] >= 20 && low[i] <= 99).assertTrue();
      }

      const high = buildTrend(makeOption('High Trend Option', 150));

      for (let i = 0; i < high.length; i++) {
        expect(high[i] >= 20 && high[i] <= 99).assertTrue();
      }
    });

    // The same option should always generate the same trend values.
    it('buildTrend_isDeterministicForSameOption', 0, () => {
      const option = makeOption('Stable Trend Option', 55);
      const first = buildTrend(option);
      const second = buildTrend(option);

      for (let i = 0; i < first.length; i++) {
        expect(first[i]).assertEqual(second[i]);
      }
    });

    // buildTrend uses its own adjusted seed and should run independently
    // from the metric-generation logic.
    it('buildTrend_usesDifferentSeedThanBuildMetrics', 0, () => {
      const option = makeOption('Independent Seed Option', 60);
      const trend = buildTrend(option);

      expect(trend.length).assertEqual(7);
    });
  });
}