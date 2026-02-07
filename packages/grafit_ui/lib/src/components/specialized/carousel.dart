import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Carousel orientation
enum GrafitCarouselOrientation {
  horizontal,
  vertical,
}

/// Carousel API for external control
class GrafitCarouselApi {
  final PageController? controller;
  final int itemCount;
  final ValueNotifier<int> _currentIndexNotifier;
  final VoidCallback? _scrollToNext;
  final VoidCallback? _scrollToPrevious;
  final Function(int)? _scrollToIndex;

  GrafitCarouselApi({
    this.controller,
    required this.itemCount,
    required ValueNotifier<int> currentIndexNotifier,
    VoidCallback? scrollToNext,
    VoidCallback? scrollToPrevious,
    Function(int)? scrollToIndex,
  })  : _currentIndexNotifier = currentIndexNotifier,
        _scrollToNext = scrollToNext,
        _scrollToPrevious = scrollToPrevious,
        _scrollToIndex = scrollToIndex;

  /// Current selected index
  int get currentIndex => _currentIndexNotifier.value;

  /// Stream of index changes
  Stream<int> get onIndexChanged => _currentIndexNotifier.stream;

  /// Check if can scroll to previous
  bool get canScrollPrev => currentIndex > 0;

  /// Check if can scroll to next
  bool get canScrollNext => currentIndex < itemCount - 1;

  /// Scroll to next item
  void scrollNext() => _scrollToNext?.call();

  /// Scroll to previous item
  void scrollPrev() => _scrollToPrevious?.call();

  /// Scroll to specific index
  void scrollToIndex(int index) => _scrollToIndex?.call(index);
}

/// Main Carousel widget
class GrafitCarousel extends StatefulWidget {
  /// List of carousel items
  final List<Widget> items;

  /// Initial index
  final int initialIndex;

  /// Carousel orientation
  final GrafitCarouselOrientation orientation;

  /// Auto-play delay in seconds (null to disable)
  final double? autoPlayDelay;

  /// Enable infinite loop
  final bool loop;

  /// Enable touch swipe
  final bool enableSwipe;

  /// Height for horizontal carousel (null for unconstrained)
  final double? height;

  /// Width for vertical carousel (null for unconstrained)
  final double? width;

  /// Animation duration
  final Duration animationDuration;

  /// Animation curve
  final Curve animationCurve;

  /// Viewport fraction (how much of each item is visible)
  final double viewportFraction;

  /// Spacing between items
  final double spacing;

  /// Callback when index changes
  final ValueChanged<int>? onIndexChanged;

  /// Callback when API is ready
  final ValueChanged<GrafitCarouselApi>? onApiReady;

  /// Show navigation arrows
  final bool showArrows;

  /// Show dot indicators
  final bool showIndicators;

  /// Custom previous button
  final Widget? previousButton;

  /// Custom next button
  final Widget? nextButton;

  const GrafitCarousel({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.orientation = GrafitCarouselOrientation.horizontal,
    this.autoPlayDelay,
    this.loop = false,
    this.enableSwipe = true,
    this.height,
    this.width,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.viewportFraction = 1.0,
    this.spacing = 0,
    this.onIndexChanged,
    this.onApiReady,
    this.showArrows = true,
    this.showIndicators = true,
    this.previousButton,
    this.nextButton,
  });

  @override
  State<GrafitCarousel> createState() => GrafitCarouselState();
}

class GrafitCarouselState extends State<GrafitCarousel> {
  late PageController _pageController;
  late ValueNotifier<int> _currentIndexNotifier;
  Timer? _autoPlayTimer;
  late int _actualIndex;

  @override
  void initState() {
    super.initState();
    _actualIndex = widget.initialIndex;
    _currentIndexNotifier = ValueNotifier<int>(widget.initialIndex);

    // Handle loop offset for initial index
    final initialPage = widget.loop ? 100000 + widget.initialIndex : widget.initialIndex;

    _pageController = PageController(
      initialPage: initialPage,
      viewportFraction: widget.viewportFraction,
    );

    // Notify API ready
    if (widget.onApiReady != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onApiReady!(_createApi());
      });
    }

    // Start auto-play if enabled
    if (widget.autoPlayDelay != null) {
      _startAutoPlay();
    }
  }

  GrafitCarouselApi _createApi() {
    return GrafitCarouselApi(
      controller: _pageController,
      itemCount: widget.items.length,
      currentIndexNotifier: _currentIndexNotifier,
      scrollToNext: widget.loop ? _scrollNext : _canScrollNext() ? _scrollNext : null,
      scrollToPrevious: widget.loop ? _scrollPrevious : _canScrollPrevious() ? _scrollPrevious : null,
      scrollToIndex: (index) {
        if (index >= 0 && index < widget.items.length) {
          final targetPage = widget.loop ? 100000 + index : index;
          _pageController.animateToPage(
            targetPage,
            duration: widget.animationDuration,
            curve: widget.animationCurve,
          );
        }
      },
    );
  }

  bool _canScrollNext() => _actualIndex < widget.items.length - 1;

  bool _canScrollPrevious() => _actualIndex > 0;

  void _scrollNext() {
    if (widget.loop || _canScrollNext()) {
      _pageController.nextPage(
        duration: widget.animationDuration,
        curve: widget.animationCurve,
      );
    }
  }

  void _scrollPrevious() {
    if (widget.loop || _canScrollPrevious()) {
      _pageController.previousPage(
        duration: widget.animationDuration,
        curve: widget.animationCurve,
      );
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(
      Duration(milliseconds: (widget.autoPlayDelay! * 1000).round()),
      (_) => _scrollNext(),
    );
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  @override
  void didUpdateWidget(GrafitCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoPlayDelay != oldWidget.autoPlayDelay) {
      _stopAutoPlay();
      if (widget.autoPlayDelay != null) {
        _startAutoPlay();
      }
    }
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final isHorizontal = widget.orientation == GrafitCarouselOrientation.horizontal;

    // Build items with loop support
    final displayItems = widget.loop
        ? [...widget.items, ...widget.items]
        : widget.items;

    return GrafitCarouselInternalProvider(
      state: this,
      child: Container(
        height: isHorizontal ? widget.height : null,
        width: isHorizontal ? null : widget.width,
        child: Focus(
          onKeyEvent: (_, event) {
            // Handle keyboard navigation
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowLeft && isHorizontal) {
                _scrollPrevious();
                return KeyEventResult.handled;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowRight && isHorizontal) {
                _scrollNext();
                return KeyEventResult.handled;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && !isHorizontal) {
                _scrollPrevious();
                return KeyEventResult.handled;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowDown && !isHorizontal) {
                _scrollNext();
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: Stack(
            children: [
              // Main carousel content
              _buildContent(isHorizontal, colors),
              // Navigation arrows
              if (widget.showArrows) _buildNavigation(isHorizontal),
              // Dot indicators
              if (widget.showIndicators && widget.items.length > 1)
                _buildIndicators(isHorizontal, colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isHorizontal, GrafitColorScheme colors) {
    return GrafitCarouselContent(
      orientation: widget.orientation,
      spacing: widget.spacing,
      enableSwipe: widget.enableSwipe,
      pageController: _pageController,
      onPageChanged: (index) {
        final newIndex = widget.loop
            ? index % widget.items.length
            : index;
        setState(() {
          _actualIndex = newIndex;
          _currentIndexNotifier.value = newIndex;
        });
        widget.onIndexChanged?.call(newIndex);
      },
      items: widget.loop
          ? [...widget.items, ...widget.items]
          : widget.items,
    );
  }

  Widget _buildNavigation(bool isHorizontal) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndexNotifier,
      builder: (context, index, _) {
        return Stack(
          children: [
            if (widget.previousButton != null)
              Positioned(
                left: isHorizontal ? -12 : null,
                top: isHorizontal ? null : -48,
                right: isHorizontal ? null : 0,
                child: widget.previousButton!,
              )
            else if (widget.showArrows)
              Positioned(
                left: isHorizontal ? -12 : null,
                top: isHorizontal ? null : -48,
                right: isHorizontal ? null : 0,
                child: GrafitCarouselPrevious(
                  orientation: widget.orientation,
                  onPressed: (widget.loop || _canScrollPrevious()) ? _scrollPrevious : null,
                ),
              ),
            if (widget.nextButton != null)
              Positioned(
                right: isHorizontal ? -12 : null,
                top: isHorizontal ? null : null,
                bottom: isHorizontal ? null : -48,
                left: isHorizontal ? null : 0,
                child: widget.nextButton!,
              )
            else if (widget.showArrows)
              Positioned(
                right: isHorizontal ? -12 : null,
                top: isHorizontal ? null : null,
                bottom: isHorizontal ? null : -48,
                left: isHorizontal ? null : 0,
                child: GrafitCarouselNext(
                  orientation: widget.orientation,
                  onPressed: (widget.loop || _canScrollNext()) ? _scrollNext : null,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildIndicators(bool isHorizontal, GrafitColorScheme colors) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: isHorizontal ? -16 : null,
      top: isHorizontal ? null : 0,
      child: GrafitCarouselIndicator(
        count: widget.items.length,
        currentIndex: _actualIndex,
        orientation: widget.orientation,
        onDotPressed: (index) {
          final targetPage = widget.loop ? 100000 + index : index;
          _pageController.animateToPage(
            targetPage,
            duration: widget.animationDuration,
            curve: widget.animationCurve,
          );
        },
      ),
    );
  }
}

/// Inherited widget for sharing carousel state
class GrafitCarouselInternalProvider extends InheritedWidget {
  final GrafitCarouselState state;

  const GrafitCarouselInternalProvider({
    super.key,
    required this.state,
    required Widget child,
  }) : super(child: child);

  static GrafitCarouselInternalProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GrafitCarouselInternalProvider>();
  }

  @override
  bool updateShouldNotify(GrafitCarouselInternalProvider oldWidget) {
    return state != oldWidget.state;
  }
}

/// Carousel content wrapper
class GrafitCarouselContent extends StatelessWidget {
  final GrafitCarouselOrientation orientation;
  final double spacing;
  final bool enableSwipe;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final List<Widget> items;

  const GrafitCarouselContent({
    super.key,
    required this.orientation,
    required this.spacing,
    required this.enableSwipe,
    required this.pageController,
    required this.onPageChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isHorizontal = orientation == GrafitCarouselOrientation.horizontal;

    return ClipRect(
      child: PageView.builder(
        controller: pageController,
        scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
        onPageChanged: onPageChanged,
        physics: enableSwipe
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isHorizontal ? spacing / 2 : 0,
              vertical: isHorizontal ? 0 : spacing / 2,
            ),
            child: items[index],
          );
        },
      ),
    );
  }
}

/// Individual carousel item
class GrafitCarouselItem extends StatelessWidget {
  final Widget child;
  final bool flex;

  const GrafitCarouselItem({
    super.key,
    required this.child,
    this.flex = true,
  });

  @override
  Widget build(BuildContext context) {
    if (flex) {
      return Expanded(
        child: child,
      );
    }
    return child;
  }
}

/// Previous navigation button
class GrafitCarouselPrevious extends StatelessWidget {
  final GrafitCarouselOrientation orientation;
  final VoidCallback? onPressed;

  const GrafitCarouselPrevious({
    super.key,
    required this.orientation,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final isHorizontal = orientation == GrafitCarouselOrientation.horizontal;

    return Semantics(
      label: 'Previous slide',
      button: true,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colors.border),
          color: onPressed == null ? colors.muted : colors.background,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Icon(
              isHorizontal ? Icons.chevron_left : Icons.expand_less,
              size: 20,
              color: onPressed == null
                  ? colors.mutedForeground
                  : colors.foreground,
            ),
          ),
        ),
      ),
    );
  }
}

/// Next navigation button
class GrafitCarouselNext extends StatelessWidget {
  final GrafitCarouselOrientation orientation;
  final VoidCallback? onPressed;

  const GrafitCarouselNext({
    super.key,
    required this.orientation,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final isHorizontal = orientation == GrafitCarouselOrientation.horizontal;

    return Semantics(
      label: 'Next slide',
      button: true,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colors.border),
          color: onPressed == null ? colors.muted : colors.background,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Icon(
              isHorizontal ? Icons.chevron_right : Icons.expand_more,
              size: 20,
              color: onPressed == null
                  ? colors.mutedForeground
                  : colors.foreground,
            ),
          ),
        ),
      ),
    );
  }
}

/// Dot indicator for carousel
class GrafitCarouselIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final GrafitCarouselOrientation orientation;
  final ValueChanged<int> onDotPressed;

  const GrafitCarouselIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.orientation,
    required this.onDotPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final isHorizontal = orientation == GrafitCarouselOrientation.horizontal;

    if (count <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < count; i++)
          GestureDetector(
            onTap: () => onDotPressed(i),
            child: Semantics(
              label: 'Go to slide ${i + 1}',
              button: true,
              selected: i == currentIndex,
              child: Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(
                  horizontal: isHorizontal ? 2 : 0,
                  vertical: isHorizontal ? 0 : 2,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == currentIndex
                      ? colors.primary
                      : colors.muted,
                  border: Border.all(
                    color: i == currentIndex
                        ? colors.primary
                        : colors.border,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Extension for ValueNotifier to provide stream
extension ValueNotifierExtension<T> on ValueNotifier<T> {
  Stream<T> get stream {
    StreamController<T>? controller;
    void onData() {
      if (controller != null && controller!.hasListener) {
        controller!.add(value);
      }
    }

    void onListen() {
      addListener(onData);
    }

    void onCancel() {
      removeListener(onData);
    }

    controller = StreamController<T>(
      onListen: onListen,
      onCancel: onCancel,
    );

    return controller.stream;
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default Horizontal',
  type: GrafitCarousel,
  path: 'Specialized/Carousel',
)
Widget carouselDefaultHorizontal(BuildContext context) {
  return SizedBox(
    height: 200,
    child: GrafitCarousel(
      items: [
        _buildCarouselItem('Slide 1', Colors.blue),
        _buildCarouselItem('Slide 2', Colors.green),
        _buildCarouselItem('Slide 3', Colors.orange),
        _buildCarouselItem('Slide 4', Colors.purple),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Vertical',
  type: GrafitCarousel,
  path: 'Specialized/Carousel',
)
Widget carouselVertical(BuildContext context) {
  return SizedBox(
    width: 200,
    height: 300,
    child: GrafitCarousel(
      orientation: GrafitCarouselOrientation.vertical,
      items: [
        _buildCarouselItem('Slide 1', Colors.blue),
        _buildCarouselItem('Slide 2', Colors.green),
        _buildCarouselItem('Slide 3', Colors.orange),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Auto Play',
  type: GrafitCarousel,
  path: 'Specialized/Carousel',
)
Widget carouselAutoPlay(BuildContext context) {
  final autoPlayDelay = context.knobs.double.slider(
    label: 'Auto Play Delay (seconds)',
    initialValue: 2.0,
    min: 0.5,
    max: 5.0,
  );

  return SizedBox(
    height: 200,
    child: GrafitCarousel(
      autoPlayDelay: autoPlayDelay,
      items: [
        _buildCarouselItem('Auto 1', Colors.red),
        _buildCarouselItem('Auto 2', Colors.blue),
        _buildCarouselItem('Auto 3', Colors.green),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Loop',
  type: GrafitCarousel,
  path: 'Specialized/Carousel',
)
Widget carouselWithLoop(BuildContext context) {
  final loop = context.knobs.boolean(
    label: 'Loop',
    initialValue: true,
  );

  final showArrows = context.knobs.boolean(
    label: 'Show Arrows',
    initialValue: true,
  );

  final showIndicators = context.knobs.boolean(
    label: 'Show Indicators',
    initialValue: true,
  );

  return SizedBox(
    height: 200,
    child: GrafitCarousel(
      loop: loop,
      showArrows: showArrows,
      showIndicators: showIndicators,
      items: [
        _buildCarouselItem('Loop 1', Colors.teal),
        _buildCarouselItem('Loop 2', Colors.indigo),
        _buildCarouselItem('Loop 3', Colors.amber),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Spacing',
  type: GrafitCarousel,
  path: 'Specialized/Carousel',
)
Widget carouselCustomSpacing(BuildContext context) {
  final spacing = context.knobs.double.slider(
    label: 'Spacing',
    initialValue: 16.0,
    min: 0.0,
    max: 32.0,
  );

  final viewportFraction = context.knobs.double.slider(
    label: 'Viewport Fraction',
    initialValue: 0.85,
    min: 0.5,
    max: 1.0,
  );

  return SizedBox(
    height: 200,
    child: GrafitCarousel(
      spacing: spacing,
      viewportFraction: viewportFraction,
      items: [
        _buildCarouselItem('Card 1', Colors.pink),
        _buildCarouselItem('Card 2', Colors.cyan),
        _buildCarouselItem('Card 3', Colors.lime),
        _buildCarouselItem('Card 4', Colors.deepOrange),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'No Swipe',
  type: GrafitCarousel,
  path: 'Specialized/Carousel',
)
Widget carouselNoSwipe(BuildContext context) {
  return SizedBox(
    height: 200,
    child: GrafitCarousel(
      enableSwipe: false,
      items: [
        _buildCarouselItem('Static 1', Colors.brown),
        _buildCarouselItem('Static 2', Colors.grey),
        _buildCarouselItem('Static 3', Colors.blueGrey),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitCarousel,
  path: 'Specialized/Carousel',
)
Widget carouselInteractive(BuildContext context) {
  final orientation = context.knobs.list(
    label: 'Orientation',
    options: GrafitCarouselOrientation.values,
    initialOption: GrafitCarouselOrientation.horizontal,
  );

  final loop = context.knobs.boolean(
    label: 'Loop',
    initialValue: false,
  );

  final autoPlayDelay = context.knobs.double.slider(
    label: 'Auto Play Delay (seconds)',
    initialValue: 0.0,
    min: 0.0,
    max: 5.0,
  );

  final enableSwipe = context.knobs.boolean(
    label: 'Enable Swipe',
    initialValue: true,
  );

  final spacing = context.knobs.double.slider(
    label: 'Spacing',
    initialValue: 0.0,
    min: 0.0,
    max: 24.0,
  );

  final viewportFraction = context.knobs.double.slider(
    label: 'Viewport Fraction',
    initialValue: 1.0,
    min: 0.6,
    max: 1.0,
  );

  final showArrows = context.knobs.boolean(
    label: 'Show Arrows',
    initialValue: true,
  );

  final showIndicators = context.knobs.boolean(
    label: 'Show Indicators',
    initialValue: true,
  );

  final isHorizontal = orientation == GrafitCarouselOrientation.horizontal;

  return SizedBox(
    height: isHorizontal ? 200 : null,
    width: isHorizontal ? null : 200,
    child: GrafitCarousel(
      orientation: orientation,
      loop: loop,
      autoPlayDelay: autoPlayDelay > 0 ? autoPlayDelay : null,
      enableSwipe: enableSwipe,
      spacing: spacing,
      viewportFraction: viewportFraction,
      showArrows: showArrows,
      showIndicators: showIndicators,
      items: [
        _buildCarouselItem('Interactive 1', Colors.deepPurple),
        _buildCarouselItem('Interactive 2', Colors.lightBlue),
        _buildCarouselItem('Interactive 3', Colors.lightGreen),
      ],
    ),
  );
}

// Helper widget for building carousel items
Widget _buildCarouselItem(String text, Color color) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
