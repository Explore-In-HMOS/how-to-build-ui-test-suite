import { AnalyzerOption } from '../common/AnalyzerOptions';

export class Metric {
  label: string;
  value: number;

  constructor(label: string, value: number) {
    this.label = label;
    this.value = value;
  }
}

export function hashString(str: string): number {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = (hash << 5) - hash + str.charCodeAt(i);
    hash |= 0;
  }
  return Math.abs(hash);
}

export function seededVariance(seed: number, index: number, spread: number): number {
  const n = Math.sin(seed + index * 12.9898) * 43758.5453;
  const frac = n - Math.floor(n);
  return Math.round((frac - 0.5) * 2 * spread);
}

export function buildMetrics(option: AnalyzerOption): Metric[] {
  const seed = hashString(option.title);
  const labels: string[] = ['Consistency', 'Accuracy', 'Efficiency', 'Power'];
  const result: Metric[] = [];
  for (let i = 0; i < labels.length; i++) {
    const v = option.currentScore + seededVariance(seed, i, 14);
    const clamped = Math.min(99, Math.max(35, v));
    result.push(new Metric(labels[i], clamped));
  }
  return result;
}

export function buildTrend(option: AnalyzerOption): number[] {
  const seed = hashString(option.title) + 7;
  const points: number[] = [];
  for (let i = 0; i < 7; i++) {
    const v = option.currentScore + seededVariance(seed, i, 18);
    points.push(Math.min(99, Math.max(20, v)));
  }
  return points;
}