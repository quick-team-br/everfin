import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:desenrolai/core/theme/app_gradients.dart';

import '../view_models/month_selector_viewmodel.dart';

class MonthSelector extends ConsumerStatefulWidget {
  final void Function(int)? onChange;
  final Color? primaryColor;
  final Gradient? gradient;

  const MonthSelector({
    super.key,
    this.onChange,
    this.primaryColor,
    this.gradient,
  });

  @override
  _MonthSelectorState createState() => _MonthSelectorState();
}

class _MonthSelectorState extends ConsumerState<MonthSelector> {
  late PageController _pageController;
  double _lastPage = 1;

  @override
  void initState() {
    super.initState();
    final index = ref.read(monthSelectorProvider);
    _pageController = PageController(
      initialPage: index,
      viewportFraction: 1 / 3,
    );

    _pageController.addListener(() {
      final current = _pageController.page ?? _lastPage;
      _lastPage = current;
      final index = current.round();
      if (index != ref.read(monthSelectorProvider)) {
        ref.read(monthSelectorProvider.notifier).selectIndex(index);
        widget.onChange?.call(index);
      }
    });
  }

  void _goToIndex(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(monthSelectorProvider);
    final viewModel = ref.read(monthSelectorProvider.notifier);
    final primaryColor = widget.primaryColor ?? Theme.of(context).primaryColor;
    final buttonGradient = widget.gradient ?? AppGradients.primary;

    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/svgs/arrow_with_shadow_icon.svg',
              width: 24,
              colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
              semanticsLabel: "Mês anterior",
            ),
            onPressed: () => _goToIndex(selectedIndex - 1),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: viewModel.months.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == selectedIndex;

                    return Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.transparent
                                  : Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color!,
                        ),
                        child: Text(viewModel.months[index]),
                      ),
                    );
                  },
                ),

                IgnorePointer(
                  child: Align(
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: buttonGradient,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        viewModel.months[selectedIndex],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Transform.rotate(
              angle: 3.14159, // 180 degrees in radians
              child: SvgPicture.asset(
                'assets/svgs/arrow_with_shadow_icon.svg',
                width: 24,
                colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                semanticsLabel: "Próximo mês",
              ),
            ),
            onPressed: () => _goToIndex(selectedIndex + 1),
          ),
        ],
      ),
    );
  }
}
