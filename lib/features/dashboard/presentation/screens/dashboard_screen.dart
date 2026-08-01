import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/animations/animations.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/daily_quote_card.dart';
import '../widgets/greeting_header.dart';
import '../widgets/planner_preview_card.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_activity_list.dart';
import '../widgets/study_streak_card.dart';
import '../widgets/today_focus_card.dart';
import '../widgets/xp_summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 32),
              sliver: SliverList.list(
                children: [
                  const GreetingHeader(),
                  AppSpacing.gapXl,
                  const FadeInWidget(child: TodayFocusCard()),
                  AppSpacing.gapXl,
                  Text('Quick Actions', style: AppTypography.h3),
                  AppSpacing.gapMd,
                  const QuickActionsGrid(),
                  AppSpacing.gapXl,
                  const PlannerPreviewCard(),
                  AppSpacing.gapXl,
                  const DailyQuoteCard(),
                  AppSpacing.gapXl,
                  const StudyStreakCard(),
                  AppSpacing.gapXl,
                  const XpSummaryCard(),
                  AppSpacing.gapXl,
                  const RecentActivityList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
