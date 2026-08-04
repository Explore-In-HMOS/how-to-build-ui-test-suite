export interface AnalyzerOption {
  title: string;
  subtitle: string;
  currentScore: number;
  lastUpdate: string;
  status: string;
}

export const OPTIONS: AnalyzerOption[] = [
  {
    title: 'Shot Analysis',
    subtitle: 'Reviews shot attempts, release consistency, and overall shooting accuracy.',
    currentScore: 82,
    lastUpdate: 'Updated 5 min ago',
    status: 'Ready'
  },
  {
    title: 'Dribble Analysis',
    subtitle: 'Evaluates ball control, hand movement, dribble rhythm, and handling stability.',
    currentScore: 76,
    lastUpdate: 'Updated 1 hour ago',
    status: 'In Progress'
  },
  {
    title: 'Jump Analysis',
    subtitle: 'Measures jump height, takeoff strength, landing balance, and explosiveness.',
    currentScore: 88,
    lastUpdate: 'Updated yesterday',
    status: 'Ready'
  },
  {
    title: 'Speed Analysis',
    subtitle: 'Tracks sprint speed, acceleration, reaction time, and movement intensity.',
    currentScore: 91,
    lastUpdate: 'Updated 2 days ago',
    status: 'Completed'
  },
  {
    title: 'Pass Analysis',
    subtitle: 'Analyzes pass accuracy, timing, direction, and decision-making during play.',
    currentScore: 79,
    lastUpdate: 'Updated this morning',
    status: 'Needs Review'
  },
  {
    title: 'Defense Analysis',
    subtitle: 'Checks defensive stance, lateral movement, positioning, and response speed.',
    currentScore: 84,
    lastUpdate: 'Updated last week',
    status: 'Ready'
  },
  {
    title: 'Player Summary',
    subtitle: 'Combines all analyzer results into one overall performance overview.',
    currentScore: 86,
    lastUpdate: 'Updated after last session',
    status: 'Completed'
  },
  {
    title: 'Game Report',
    subtitle: 'Creates a session-based report using mock game events and player metrics.',
    currentScore: 90,
    lastUpdate: 'Not updated yet',
    status: 'Pending'
  }
];

export function getOptionCount(): number {
  return OPTIONS.length;
}

export function getOptionTitle(index: number): string {
  if (index < 0 || index >= OPTIONS.length) {
    return '';
  }

  return OPTIONS[index].title;
}

export function isValidOption(option: AnalyzerOption): boolean {
  return OPTIONS.some((item: AnalyzerOption) =>
  item.title === option.title &&
    item.subtitle === option.subtitle &&
    item.currentScore === option.currentScore &&
    item.lastUpdate === option.lastUpdate &&
    item.status === option.status
  );
}

export function getStatusColor(status: string): string {
  switch (status.toLowerCase()) {
    case 'ready':
    case 'completed':
      return '#34C759';
    case 'in progress':
      return '#0A84FF';
    case 'needs review':
      return '#FF9F0A';
    case 'pending':
      return '#8E8E93';
    default:
      return '#8E8E93';
  }
}
