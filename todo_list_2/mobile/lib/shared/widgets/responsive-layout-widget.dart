import 'package:flutter/material.dart';

/// Screen width breakpoints for adaptive layouts.
class Breakpoints {
  const Breakpoints._();
  static const double tablet = 600;
  static const double desktop = 1200;
}

/// Adaptive shell that switches between:
/// - Mobile  (< 600 px) → BottomNavigationBar
/// - Tablet  (600–1199 px) → NavigationRail (side)
/// - Desktop (≥ 1200 px) → NavigationDrawer (permanent side panel)
class ResponsiveLayoutWidget extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;

  const ResponsiveLayoutWidget({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= Breakpoints.desktop) return _DesktopLayout(this);
    if (width >= Breakpoints.tablet) return _TabletLayout(this);
    return _MobileLayout(this);
  }
}

// ---------------------------------------------------------------------------
// Mobile: bottom navigation bar
// ---------------------------------------------------------------------------

class _MobileLayout extends StatelessWidget {
  final ResponsiveLayoutWidget w;
  const _MobileLayout(this.w);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: w.body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: w.selectedIndex,
        onDestinationSelected: w.onDestinationSelected,
        destinations: w.destinations,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tablet: navigation rail on the left
// ---------------------------------------------------------------------------

class _TabletLayout extends StatelessWidget {
  final ResponsiveLayoutWidget w;
  const _TabletLayout(this.w);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: w.selectedIndex,
            onDestinationSelected: w.onDestinationSelected,
            labelType: NavigationRailLabelType.selected,
            destinations: w.destinations
                .map(
                  (d) => NavigationRailDestination(
                    icon: d.icon,
                    selectedIcon: d.selectedIcon,
                    label: Text(d.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: w.body),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Desktop: permanent navigation drawer on the left
// ---------------------------------------------------------------------------

class _DesktopLayout extends StatelessWidget {
  final ResponsiveLayoutWidget w;
  const _DesktopLayout(this.w);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            selectedIndex: w.selectedIndex,
            onDestinationSelected: w.onDestinationSelected,
            children: [
              const SizedBox(height: 16),
              ...w.destinations.map(
                (d) => NavigationDrawerDestination(
                  icon: d.icon,
                  selectedIcon: d.selectedIcon,
                  label: Text(d.label),
                ),
              ),
            ],
          ),
          Expanded(child: w.body),
        ],
      ),
    );
  }
}
