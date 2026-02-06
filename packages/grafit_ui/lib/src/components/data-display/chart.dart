import 'package:flutter/material.dart';
import 'package:cristalyse/cristalyse.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';

/// Chart types supported by GrafitChart
enum GrafitChartType {
  line,
  area,
  bar,
  pie,
  scatter,
}

/// Legend position options
enum GrafitChartLegendPosition {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// Tooltip indicator style
enum GrafitChartTooltipIndicator {
  dot,
  line,
  dashed,
}

/// Configuration for chart series styling
class GrafitChartSeries {
  final String key;
  final String label;
  final Color? color;
  final IconData? icon;

  const GrafitChartSeries({
    required this.key,
    required this.label,
    this.color,
    this.icon,
  });
}

/// Chart configuration for theming
class GrafitChartConfig {
  final Map<String, GrafitChartSeries> series;
  final GrafitColorScheme colors;

  GrafitChartConfig({required this.series, required this.colors});

  /// Get color for a series key
  Color? getSeriesColor(String key) {
    return series[key]?.color;
  }

  /// Get default colors for multiple series
  static List<Color> defaultSeriesColors(GrafitColorScheme colors) {
    return [
      colors.primary,
      colors.secondary,
      colors.accent,
      colors.destructive,
      const Color(0xFF8b5cf6), // violet
      const Color(0xFF06b6d4), // cyan
      const Color(0xFFf59e0b), // amber
      const Color(0xFF10b981), // emerald
    ];
  }
}

/// Main Chart Widget - A shadcn-ui style chart component using Cristalyse
///
/// This widget provides a declarative, grammar-of-graphics API for creating
/// beautiful, animated charts with 60fps performance.
///
/// Example:
/// ```dart
/// GrafitChart(
///   data: [
///     {'month': 'Jan', 'revenue': 4500, 'expenses': 3200},
///     {'month': 'Feb', 'revenue': 5200, 'expenses': 3800},
///     {'month': 'Mar', 'revenue': 4800, 'expenses': 3500},
///   ],
///   type: GrafitChartType.line,
///   xKey: 'month',
///   yKeys: ['revenue'],
///   series: [
///     GrafitChartSeries(key: 'revenue', label: 'Revenue'),
///   ],
/// )
/// ```
class GrafitChart extends StatefulWidget {
  /// The data to display in the chart
  final List<Map<String, dynamic>> data;

  /// Chart type to render
  final GrafitChartType type;

  /// The key in the data for the x-axis
  final String xKey;

  /// The key(s) in the data for the y-axis (for multi-series charts)
  final List<String> yKeys;

  /// Optional secondary y-axis key
  final String? y2Key;

  /// Color mapping key (for grouping data by category)
  final String? colorKey;

  /// Series configuration for styling and legend
  final List<GrafitChartSeries>? series;

  /// Chart title
  final String? title;

  /// Whether to show the legend
  final bool showLegend;

  /// Legend position
  final GrafitChartLegendPosition legendPosition;

  /// Whether to show tooltips on hover
  final bool showTooltip;

  /// Tooltip indicator style
  final GrafitChartTooltipIndicator tooltipIndicator;

  /// Chart height (default is aspect video ratio)
  final double? height;

  /// Animation duration for chart transitions
  final Duration animationDuration;

  /// Custom theme override
  final ChartTheme? theme;

  /// Callback when a data point is tapped
  final void Function(Map<String, dynamic> data)? onTap;

  /// Custom tooltip builder
  final Widget Function(Map<String, dynamic> data, Offset position)?
      customTooltipBuilder;

  /// Line-specific: stroke width
  final double? strokeWidth;

  /// Line-specific: whether to fill area (for line/area charts)
  final bool? fillArea;

  /// Bar-specific: bar width multiplier
  final double? barWidth;

  /// Point-specific: point size (for scatter/line points)
  final double? pointSize;

  /// Whether to show grid lines
  final bool showGrid;

  /// Custom colors for chart elements
  final Color? primaryColor;

  const GrafitChart({
    super.key,
    required this.data,
    required this.type,
    required this.xKey,
    required this.yKeys,
    this.y2Key,
    this.colorKey,
    this.series,
    this.title,
    this.showLegend = true,
    this.legendPosition = GrafitChartLegendPosition.bottom,
    this.showTooltip = true,
    this.tooltipIndicator = GrafitChartTooltipIndicator.dot,
    this.height,
    this.animationDuration = const Duration(milliseconds: 300),
    this.theme,
    this.onTap,
    this.customTooltipBuilder,
    this.strokeWidth,
    this.fillArea,
    this.barWidth,
    this.pointSize,
    this.showGrid = true,
    this.primaryColor,
  });

  @override
  State<GrafitChart> createState() => _GrafitChartState();
}

class _GrafitChartState extends State<GrafitChart> {
  @override
  Widget build(BuildContext context) {
    final grafitTheme = Theme.of(context).extension<GrafitTheme>()!;
    final config = _buildConfig(grafitTheme.colors);

    Widget chartWidget = _buildChart(config, grafitTheme);

    if (widget.title != null) {
      chartWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Text(
              widget.title!,
              style: grafitTheme.text.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          chartWidget,
        ],
      );
    }

    return chartWidget;
  }

  GrafitChartConfig _buildConfig(GrafitColorScheme colors) {
    final seriesMap = <String, GrafitChartSeries>{};

    if (widget.series != null) {
      for (final series in widget.series!) {
        seriesMap[series.key] = series;
      }
    } else {
      // Auto-generate series from yKeys
      final defaultColors = GrafitChartConfig.defaultSeriesColors(colors);
      for (var i = 0; i < widget.yKeys.length; i++) {
        final key = widget.yKeys[i];
        seriesMap[key] = GrafitChartSeries(
          key: key,
          label: _capitalize(key),
          color: defaultColors[i % defaultColors.length],
        );
      }
    }

    return GrafitChartConfig(series: seriesMap, colors: colors);
  }

  Widget _buildChart(GrafitChartConfig config, GrafitTheme grafitTheme) {
    final effectiveColor = widget.primaryColor ?? config.colors.primary;

    switch (widget.type) {
      case GrafitChartType.line:
        return _buildLineChart(config, effectiveColor);
      case GrafitChartType.area:
        return _buildAreaChart(config, effectiveColor);
      case GrafitChartType.bar:
        return _buildBarChart(config, effectiveColor);
      case GrafitChartType.pie:
        return _buildPieChart(config);
      case GrafitChartType.scatter:
        return _buildScatterChart(config, effectiveColor);
    }
  }

  Widget _buildLineChart(GrafitChartConfig config, Color primaryColor) {
    final chart = CristalyseChart()
        .data(widget.data)
        .mapping(
          x: widget.xKey,
          y: widget.yKeys.first,
          color: widget.colorKey,
        )
        .geomLine(
          strokeWidth: widget.strokeWidth ?? 2.5,
          color: primaryColor.withValues(alpha: 0.9),
        )
        .geomPoint(
          size: widget.pointSize ?? 4.0,
          color: primaryColor,
          shape: PointShape.circle,
        );

    return _buildChartWidget(chart, config);
  }

  Widget _buildAreaChart(GrafitChartConfig config, Color primaryColor) {
    final chart = CristalyseChart()
        .data(widget.data)
        .mapping(
          x: widget.xKey,
          y: widget.yKeys.first,
          color: widget.colorKey,
        )
        .geomArea(
          strokeWidth: widget.strokeWidth ?? 2.0,
          color: primaryColor,
        )
        .geomLine(
          strokeWidth: 2.0,
          color: primaryColor.withValues(alpha: 0.8),
        );

    return _buildChartWidget(chart, config);
  }

  Widget _buildBarChart(GrafitChartConfig config, Color primaryColor) {
    final chart = CristalyseChart()
        .data(widget.data)
        .mapping(
          x: widget.xKey,
          y: widget.yKeys.first,
          color: widget.colorKey,
        )
        .geomBar(
          width: widget.barWidth ?? 0.8,
          color: primaryColor,
        );

    return _buildChartWidget(chart, config);
  }

  Widget _buildPieChart(GrafitChartConfig config) {
    final valueKey = widget.yKeys.first;
    final categoryKey = widget.colorKey ?? widget.xKey;

    final chart = CristalyseChart()
        .data(widget.data)
        .mappingPie(value: valueKey, category: categoryKey)
        .geomPie(
          innerRadius: 0.0,
        );

    return _buildChartWidget(chart, config);
  }

  Widget _buildScatterChart(GrafitChartConfig config, Color primaryColor) {
    final chart = CristalyseChart()
        .data(widget.data)
        .mapping(
          x: widget.xKey,
          y: widget.yKeys.first,
          color: widget.colorKey,
        )
        .geomPoint(
          size: widget.pointSize ?? 8.0,
          color: primaryColor,
          shape: PointShape.circle,
        );

    return _buildChartWidget(chart, config);
  }

  Widget _buildChartWidget(CristalyseChart chart, GrafitChartConfig config) {
    // Configure scales
    chart = chart.scaleXOrdinal();
    chart = chart.scaleYContinuous();

    // Configure legend
    if (widget.showLegend && widget.colorKey != null) {
      chart = chart.legend(
        position: _mapLegendPosition(widget.legendPosition),
        interactive: true,
      );
    }

    // Configure tooltip
    if (widget.showTooltip) {
      chart = chart.tooltip(
        (point) {
          return widget.customTooltipBuilder != null
              ? widget.customTooltipBuilder!(point.data, point.screenPosition)
              : _buildDefaultTooltip(point, config);
        },
      );
    }

    // Configure tap callback
    if (widget.onTap != null) {
      chart = chart.interaction(
        click: ClickConfig(
          onTap: (point) {
            widget.onTap!(point.data);
          },
        ),
      );
    }

    // Configure theme
    final chartTheme = widget.theme ?? _buildChartTheme(config);
    chart = chart.theme(chartTheme);

    // Build the chart widget
    final chartWidget = chart.build();

    // Wrap with container for sizing and styling
    final container = Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(config.colors.radius * 8),
        border: Border.all(
          color: config.colors.border.withValues(alpha: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: chartWidget,
      ),
    );

    return container;
  }

  Widget _buildDefaultTooltip(
    DataPointInfo point,
    GrafitChartConfig config,
  ) {
    final items = <Widget>[];
    final data = point.data;

    // Add label
    final xValue = data[widget.xKey]?.toString() ?? '';
    if (xValue.isNotEmpty) {
      items.add(
        Text(
          xValue,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: config.colors.foreground,
          ),
        ),
      );
      items.add(const SizedBox(height: 4));
    }

    // Add values
    for (final yKey in widget.yKeys) {
      final series = config.series[yKey];
      final label = series?.label ?? _capitalize(yKey);
      final value = data[yKey];
      final color = series?.color ?? config.colors.primary;

      items.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: config.colors.mutedForeground,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value?.toString() ?? 'N/A',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: config.colors.foreground,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: config.colors.background,
        borderRadius: BorderRadius.circular(config.colors.radius * 6),
        border: Border.all(
          color: config.colors.border.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  ChartTheme _buildChartTheme(GrafitChartConfig config) {
    final defaultColors = GrafitChartConfig.defaultSeriesColors(config.colors);

    return ChartTheme(
      backgroundColor: Colors.transparent,
      plotBackgroundColor: Colors.transparent,
      primaryColor: widget.primaryColor ?? config.colors.primary,
      borderColor: config.colors.border,
      gridColor: widget.showGrid
          ? config.colors.border.withValues(alpha: 0.3)
          : Colors.transparent,
      axisColor: config.colors.mutedForeground,
      gridWidth: 0.5,
      axisWidth: 1.0,
      pointSizeDefault: 4.0,
      pointSizeMin: 2.0,
      pointSizeMax: 12.0,
      colorPalette: defaultColors,
      padding: const EdgeInsets.only(left: 40, right: 20, top: 20, bottom: 40),
      axisTextStyle: TextStyle(
        fontSize: 12,
        color: config.colors.mutedForeground,
      ),
    );
  }

  LegendPosition _mapLegendPosition(GrafitChartLegendPosition position) {
    switch (position) {
      case GrafitChartLegendPosition.top:
        return LegendPosition.top;
      case GrafitChartLegendPosition.bottom:
        return LegendPosition.bottom;
      case GrafitChartLegendPosition.left:
        return LegendPosition.left;
      case GrafitChartLegendPosition.right:
        return LegendPosition.right;
      case GrafitChartLegendPosition.topLeft:
        return LegendPosition.topLeft;
      case GrafitChartLegendPosition.topRight:
        return LegendPosition.topRight;
      case GrafitChartLegendPosition.bottomLeft:
        return LegendPosition.bottomLeft;
      case GrafitChartLegendPosition.bottomRight:
        return LegendPosition.bottomRight;
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

/// Chart container widget for wrapping chart content with theming
///
/// Provides a styled container for chart widgets with consistent styling
class GrafitChartContainer extends StatelessWidget {
  final Widget child;
  final String? id;
  final double? height;
  final double? aspectRatio;
  final EdgeInsetsGeometry? padding;
  final bool showBorder;

  const GrafitChartContainer({
    super.key,
    required this.child,
    this.id,
    this.height,
    this.aspectRatio,
    this.padding,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final container = Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: showBorder
          ? BoxDecoration(
              border: Border.all(
                color: colors.border.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(colors.radius * 8),
            )
          : null,
      child: aspectRatio != null
          ? AspectRatio(aspectRatio: aspectRatio!, child: child)
          : child,
    );

    return container;
  }
}

/// Chart tooltip widget for custom tooltip display
class GrafitChartTooltip extends StatelessWidget {
  final String title;
  final List<GrafitChartTooltipItem> items;
  final Color? backgroundColor;
  final Color? textColor;
  final GrafitChartTooltipIndicator indicator;

  const GrafitChartTooltip({
    super.key,
    required this.title,
    required this.items,
    this.backgroundColor,
    this.textColor,
    this.indicator = GrafitChartTooltipIndicator.dot,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final bg = backgroundColor ?? colors.background;
    final text = textColor ?? colors.foreground;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(colors.radius * 6),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: text,
            ),
          ),
          const SizedBox(height: 6),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: _buildTooltipItem(item, colors),
              )),
        ],
      ),
    );
  }

  Widget _buildTooltipItem(GrafitChartTooltipItem item, GrafitColorScheme colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIndicator(item.color),
        const SizedBox(width: 8),
        Text(
          item.label,
          style: TextStyle(
            fontSize: 11,
            color: colors.mutedForeground,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          item.value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(Color color) {
    switch (indicator) {
      case GrafitChartTooltipIndicator.dot:
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        );
      case GrafitChartTooltipIndicator.line:
        return Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      case GrafitChartTooltipIndicator.dashed:
        return Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(1),
          ),
        );
    }
  }
}

/// Tooltip item data class
class GrafitChartTooltipItem {
  final String label;
  final String value;
  final Color color;

  const GrafitChartTooltipItem({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// Chart legend widget for displaying series information
class GrafitChartLegend extends StatelessWidget {
  final List<GrafitChartLegendItem> items;
  final GrafitChartLegendPosition position;
  final MainAxisAlignment alignment;

  const GrafitChartLegend({
    super.key,
    required this.items,
    this.position = GrafitChartLegendPosition.bottom,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final isVertical = position == GrafitChartLegendPosition.left ||
        position == GrafitChartLegendPosition.right;

    final children = items.map((item) => _buildLegendItem(item)).toList();

    Widget content;
    if (isVertical) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: _getCrossAxisAlignment(position),
        children: children,
      );
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: alignment,
        children: children,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: content,
    );
  }

  Widget _buildLegendItem(GrafitChartLegendItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.icon != null)
            Icon(item.icon, size: 16, color: item.color)
          else
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          const SizedBox(width: 6),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12,
              color: item.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  CrossAxisAlignment _getCrossAxisAlignment(GrafitChartLegendPosition position) {
    switch (position) {
      case GrafitChartLegendPosition.left:
      case GrafitChartLegendPosition.topLeft:
      case GrafitChartLegendPosition.bottomLeft:
        return CrossAxisAlignment.start;
      case GrafitChartLegendPosition.right:
      case GrafitChartLegendPosition.topRight:
      case GrafitChartLegendPosition.bottomRight:
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.center;
    }
  }
}

/// Legend item data class
class GrafitChartLegendItem {
  final String label;
  final Color color;
  final IconData? icon;

  const GrafitChartLegendItem({
    required this.label,
    required this.color,
    this.icon,
  });
}

/// Pre-built chart line widget for quick line chart creation
class GrafitChartLine extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String xKey;
  final String yKey;
  final String? colorKey;
  final String? title;
  final Color? color;
  final bool curved;
  final bool showPoints;
  final bool showArea;

  const GrafitChartLine({
    super.key,
    required this.data,
    required this.xKey,
    required this.yKey,
    this.colorKey,
    this.title,
    this.color,
    this.curved = false,
    this.showPoints = true,
    this.showArea = false,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitChart(
      data: data,
      type: showArea ? GrafitChartType.area : GrafitChartType.line,
      xKey: xKey,
      yKeys: [yKey],
      colorKey: colorKey,
      title: title,
      primaryColor: color,
      pointSize: showPoints ? 4.0 : 0.0,
    );
  }
}

/// Pre-built chart bar widget for quick bar chart creation
class GrafitChartBar extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String xKey;
  final String yKey;
  final String? colorKey;
  final String? title;
  final Color? color;
  final bool horizontal;

  const GrafitChartBar({
    super.key,
    required this.data,
    required this.xKey,
    required this.yKey,
    this.colorKey,
    this.title,
    this.color,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitChart(
      data: data,
      type: GrafitChartType.bar,
      xKey: xKey,
      yKeys: [yKey],
      colorKey: colorKey,
      title: title,
      primaryColor: color,
    );
  }
}

/// Pre-built chart area widget for quick area chart creation
class GrafitChartArea extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String xKey;
  final String yKey;
  final String? colorKey;
  final String? title;
  final Color? color;
  final double? opacity;

  const GrafitChartArea({
    super.key,
    required this.data,
    required this.xKey,
    required this.yKey,
    this.colorKey,
    this.title,
    this.color,
    this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitChart(
      data: data,
      type: GrafitChartType.area,
      xKey: xKey,
      yKeys: [yKey],
      colorKey: colorKey,
      title: title,
      primaryColor: color,
      fillArea: true,
    );
  }
}

/// Pre-built chart pie widget for quick pie chart creation
class GrafitChartPie extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String valueKey;
  final String categoryKey;
  final String? title;
  final List<Color>? colors;
  final double? innerRadius;

  const GrafitChartPie({
    super.key,
    required this.data,
    required this.valueKey,
    required this.categoryKey,
    this.title,
    this.colors,
    this.innerRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitChart(
      data: data,
      type: GrafitChartType.pie,
      xKey: categoryKey,
      yKeys: [valueKey],
      colorKey: categoryKey,
      title: title,
    );
  }
}
