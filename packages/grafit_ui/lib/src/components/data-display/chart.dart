import 'package:flutter/material.dart';
import 'package:cristalyse/cristalyse.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Chart types supported by GrafitChart
enum GrafitChartType {
  line,
  area,
  bar,
  pie,
  scatter,
  donut,
  radialBar,
  stackedBar,
  stackedArea,
  groupedBar,
  combo,
  sparkline,
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

/// Y-axis position options
enum GrafitChartYAxisPosition {
  left,
  right,
  both,
}

/// Trend direction for indicators
enum GrafitChartTrendDirection {
  up,
  down,
  neutral,
}

/// Chart stacking mode
enum GrafitChartStackMode {
  stack,
  overlay,
  percent,
}

/// Configuration for chart series styling
class GrafitChartSeries {
  final String key;
  final String label;
  final Color? color;
  final IconData? icon;
  final bool? showDataLabels;
  final String? yAxisId;
  final GrafitChartStackMode? stackMode;

  const GrafitChartSeries({
    required this.key,
    required this.label,
    this.color,
    this.icon,
    this.showDataLabels,
    this.yAxisId,
    this.stackMode,
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

  /// Shadcn-ui default color palette (Zinc theme)
  static List<Color> shadcnDefaultPalette(GrafitColorScheme colors) {
    return [
      const Color(0xFF3b82f6), // blue-500
      const Color(0xFF8b5cf6), // violet-500
      const Color(0xFFec4899), // pink-500
      const Color(0xFFf43f5e), // rose-500
      const Color(0xFFf97316), // orange-500
      const Color(0xFFeab308), // yellow-500
      const Color(0xFF22c55e), // green-500
      const Color(0xFF14b8a6), // teal-500
    ];
  }

  /// Shadcn-ui muted color palette
  static List<Color> shadcnMutedPalette(GrafitColorScheme colors) {
    return [
      const Color(0xFF94a3b8), // slate-400
      const Color(0xFFcbd5e1), // slate-300
      const Color(0xFF64748b), // slate-500
      const Color(0xFF475569), // slate-600
    ];
  }

  /// Shadcn-ui vibrant color palette
  static List<Color> shadcnVibrantPalette(GrafitColorScheme colors) {
    return [
      const Color(0xFF0ea5e9), // sky-500
      const Color(0xFFa855f7), // purple-500
      const Color(0xFFd946ef), // fuchsia-500
      const Color(0xFFef4444), // red-500
      const Color(0xFFf97316), // orange-500
      const Color(0xFFeab308), // yellow-500
      const Color(0xFF84cc16), // lime-500
      const Color(0xFF10b981), // emerald-500
      const Color(0xFF06b6d4), // cyan-500
      const Color(0xFF6366f1), // indigo-500
    ];
  }

  /// Pastel color palette for softer visuals
  static List<Color> pastelPalette(GrafitColorScheme colors) {
    return [
      const Color(0xFF93c5fd), // blue-300
      const Color(0xFFc4b5fd), // violet-300
      const Color(0xFFf9a8d4), // pink-300
      const Color(0xFFfca5a5), // red-300
      const Color(0xFFfdba74), // orange-300
      const Color(0xFFfde047), // yellow-300
      const Color(0xFFbef264), // lime-300
      const Color(0xFF6ee7b7), // emerald-300
    ];
  }

  /// Monochrome color palette for grayscale charts
  static List<Color> monochromePalette(GrafitColorScheme colors) {
    return [
      const Color(0xFF0f172a), // slate-900
      const Color(0xFF334155), // slate-700
      const Color(0xFF475569), // slate-600
      const Color(0xFF64748b), // slate-500
      const Color(0xFF94a3b8), // slate-400
      const Color(0xFFcbd5e1), // slate-300
      const Color(0xFFe2e8f0), // slate-200
    ];
  }

  /// Heatmap color palette (red to green gradient)
  static List<Color> heatmapPalette(GrafitColorScheme colors) {
    return [
      const Color(0xFFdc2626), // red-600
      const Color(0xFFea580c), // orange-600
      const Color(0xFFd97706), // amber-600
      const Color(0xFFca8a04), // yellow-600
      const Color(0xFF65a30d), // lime-600
      const Color(0xFF16a34a), // green-600
      const Color(0xFF059669), // emerald-600
    ];
  }

  /// Ocean color palette (blue to cyan gradient)
  static List<Color> oceanPalette(GrafitColorScheme colors) {
    return [
      const Color(0xFF1e3a8a), // blue-900
      const Color(0xFF1e40af), // blue-800
      const Color(0xFF2563eb), // blue-600
      const Color(0xFF3b82f6), // blue-500
      const Color(0xFF0ea5e9), // sky-500
      const Color(0xFF06b6d4), // cyan-500
      const Color(0xFF14b8a6), // teal-500
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

  /// Y-axis position (left, right, or both)
  final GrafitChartYAxisPosition yAxisPosition;

  /// Whether to show data labels on points/bars
  final bool showDataLabels;

  /// Data label formatter
  final String Function(dynamic value)? dataLabelFormatter;

  /// Donut/Radial specific: inner radius ratio (0.0 to 1.0)
  final double? innerRadius;

  /// Stacked charts: stack mode
  final GrafitChartStackMode? stackMode;

  /// Combo charts: secondary chart type (for mixed charts)
  final GrafitChartType? secondaryChartType;

  /// Sparkline specific: whether to show axes and labels
  final bool minimal;

  /// Animation curve
  final Curve animationCurve;

  /// Whether to animate on first build
  final bool animate;

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
    this.yAxisPosition = GrafitChartYAxisPosition.left,
    this.showDataLabels = false,
    this.dataLabelFormatter,
    this.innerRadius,
    this.stackMode,
    this.secondaryChartType,
    this.minimal = false,
    this.animationCurve = Curves.easeOutCubic,
    this.animate = true,
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
      case GrafitChartType.donut:
        return _buildDonutChart(config);
      case GrafitChartType.radialBar:
        return _buildRadialBarChart(config, effectiveColor);
      case GrafitChartType.stackedBar:
        return _buildStackedBarChart(config, effectiveColor);
      case GrafitChartType.stackedArea:
        return _buildStackedAreaChart(config, effectiveColor);
      case GrafitChartType.groupedBar:
        return _buildGroupedBarChart(config, effectiveColor);
      case GrafitChartType.combo:
        return _buildComboChart(config, effectiveColor);
      case GrafitChartType.sparkline:
        return _buildSparklineChart(config, effectiveColor);
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

  Widget _buildDonutChart(GrafitChartConfig config) {
    final valueKey = widget.yKeys.first;
    final categoryKey = widget.colorKey ?? widget.xKey;
    final effectiveInnerRadius = widget.innerRadius ?? 0.6;

    final chart = CristalyseChart()
        .data(widget.data)
        .mappingPie(value: valueKey, category: categoryKey)
        .geomPie(
          innerRadius: effectiveInnerRadius,
        );

    return _buildChartWidget(chart, config);
  }

  Widget _buildRadialBarChart(GrafitChartConfig config, Color primaryColor) {
    // Radial bar chart as a gauge using donut chart
    final valueKey = widget.yKeys.first;
    final categoryKey = widget.colorKey ?? widget.xKey;
    final effectiveInnerRadius = widget.innerRadius ?? 0.7;

    // Calculate max value for normalization
    final maxValue = widget.data
            .map((d) => (d[valueKey] as num?)?.toDouble() ?? 0.0)
            .reduce((a, b) => a > b ? a : b) *
        1.1;

    // Normalize data to 0-100 range for radial bars
    final normalizedData = widget.data.map((d) {
      final value = (d[valueKey] as num?)?.toDouble() ?? 0.0;
      return {
        ...d,
        '_normalized': (value / maxValue) * 100,
      };
    }).toList();

    final chart = CristalyseChart()
        .data(normalizedData)
        .mappingPie(value: '_normalized', category: categoryKey)
        .geomPie(
          innerRadius: effectiveInnerRadius,
        );

    return _buildChartWidget(chart, config);
  }

  Widget _buildStackedBarChart(GrafitChartConfig config, Color primaryColor) {
    // Stacked bar chart implementation using Cristalyse
    // Note: Cristalyse doesn't have native stacking, so we use standard bar
    // with color grouping for visual distinction
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

  Widget _buildStackedAreaChart(GrafitChartConfig config, Color primaryColor) {
    // Stacked area chart - using multiple layers
    final chart = CristalyseChart()
        .data(widget.data)
        .mapping(
          x: widget.xKey,
          y: widget.yKeys.first,
          color: widget.colorKey,
        )
        .geomArea(
          strokeWidth: widget.strokeWidth ?? 2.0,
          color: primaryColor.withValues(alpha: 0.4),
        )
        .geomLine(
          strokeWidth: 2.0,
          color: primaryColor.withValues(alpha: 0.8),
        );

    return _buildChartWidget(chart, config);
  }

  Widget _buildGroupedBarChart(GrafitChartConfig config, Color primaryColor) {
    // Grouped bar chart - using standard bar with color grouping
    final chart = CristalyseChart()
        .data(widget.data)
        .mapping(
          x: widget.xKey,
          y: widget.yKeys.first,
          color: widget.colorKey,
        )
        .geomBar(
          width: widget.barWidth ?? 0.7,
          color: primaryColor,
        );

    return _buildChartWidget(chart, config);
  }

  Widget _buildComboChart(GrafitChartConfig config, Color primaryColor) {
    final colors = GrafitChartConfig.defaultSeriesColors(config.colors);

    // Combo chart: bar + line combination on single chart
    late CristalyseChart chart;
    if (widget.yKeys.length > 1) {
      // Mixed chart: bar + line
      chart = CristalyseChart()
          .data(widget.data)
          .mapping(x: widget.xKey, y: widget.yKeys[0])
          .geomBar(width: widget.barWidth ?? 0.6, color: colors[0])
          .mapping(x: widget.xKey, y: widget.yKeys[1])
          .geomLine(strokeWidth: 2.5, color: colors[1])
          .geomPoint(size: 4.0, color: colors[1], shape: PointShape.circle);
    } else {
      chart = CristalyseChart()
          .data(widget.data)
          .mapping(
            x: widget.xKey,
            y: widget.yKeys.first,
            color: widget.colorKey,
          )
          .geomBar(width: widget.barWidth ?? 0.6, color: primaryColor.withValues(alpha: 0.6))
          .geomLine(strokeWidth: 2.5, color: primaryColor)
          .geomPoint(size: 4.0, color: primaryColor, shape: PointShape.circle);
    }

    return _buildChartWidget(chart, config);
  }

  Widget _buildSparklineChart(GrafitChartConfig config, Color primaryColor) {
    // Sparkline: minimal line chart without axes or grid
    final chart = CristalyseChart()
        .data(widget.data)
        .mapping(
          x: widget.xKey,
          y: widget.yKeys.first,
        )
        .geomLine(
          strokeWidth: widget.strokeWidth ?? 2.0,
          color: primaryColor,
        )
        .geomPoint(
          size: 0, // No points for sparkline
          color: primaryColor,
        );

    // Override theme for minimal appearance
    final minimalTheme = ChartTheme(
      backgroundColor: Colors.transparent,
      plotBackgroundColor: Colors.transparent,
      primaryColor: primaryColor,
      borderColor: Colors.transparent,
      gridColor: Colors.transparent,
      axisColor: Colors.transparent,
      gridWidth: 0,
      axisWidth: 0,
      pointSizeDefault: 0,
      pointSizeMin: 0,
      pointSizeMax: 0,
      colorPalette: const [],
      padding: EdgeInsets.zero,
      axisTextStyle: const TextStyle(fontSize: 0),
    );

    final chartWidget = chart.theme(minimalTheme).build();

    return SizedBox(
      height: widget.height ?? 60,
      width: double.infinity,
      child: chartWidget,
    );
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
    // Skip additional wrapping for sparkline (minimal) charts
    if (widget.type == GrafitChartType.sparkline || widget.minimal) {
      if (widget.showTooltip) {
        chart = chart.tooltip(
          (point) {
            return widget.customTooltipBuilder != null
                ? widget.customTooltipBuilder!(point.data, point.screenPosition)
                : _buildDefaultTooltip(point, config);
          },
        );
      }
      if (widget.onTap != null) {
        chart = chart.interaction(
          click: ClickConfig(
            onTap: (point) {
              widget.onTap!(point.data);
            },
          ),
        );
      }
      return chart.build();
    }

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

/// Pre-built chart donut widget for quick donut chart creation
class GrafitChartDonut extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String valueKey;
  final String categoryKey;
  final String? title;
  final double? innerRadius;
  final Widget? centerWidget;

  const GrafitChartDonut({
    super.key,
    required this.data,
    required this.valueKey,
    required this.categoryKey,
    this.title,
    this.innerRadius,
    this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitChart(
      data: data,
      type: GrafitChartType.donut,
      xKey: categoryKey,
      yKeys: [valueKey],
      colorKey: categoryKey,
      title: title,
      innerRadius: innerRadius,
    );
  }
}

/// Pre-built chart sparkline widget for quick sparkline creation
class GrafitChartSparkline extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String xKey;
  final String yKey;
  final Color? color;
  final double? height;
  final bool showArea;

  const GrafitChartSparkline({
    super.key,
    required this.data,
    required this.xKey,
    required this.yKey,
    this.color,
    this.height,
    this.showArea = false,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitChart(
      data: data,
      type: GrafitChartType.sparkline,
      xKey: xKey,
      yKeys: [yKey],
      primaryColor: color,
      height: height,
      minimal: true,
      showLegend: false,
      showTooltip: false,
      fillArea: showArea,
    );
  }
}

/// Chart Card component - shadcn-ui style card wrapper for charts
///
/// Provides a consistent card container with optional header,
/// description, and chart content.
class GrafitChartCard extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget chart;
  final Widget? footer;
  final Widget? action;
  final EdgeInsetsGeometry? padding;
  final bool showBorder;

  const GrafitChartCard({
    super.key,
    this.title,
    this.description,
    required this.chart,
    this.footer,
    this.action,
    this.padding,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radius * 8),
        border: showBorder
            ? Border.all(
                color: colors.border.withValues(alpha: 0.5),
              )
            : null,
        boxShadow: theme.shadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null || description != null || action != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            style: theme.text.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: colors.foreground,
                            ),
                          ),
                        if (description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            description!,
                            style: theme.text.bodySmall.copyWith(
                              fontSize: 13,
                              color: colors.mutedForeground,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (action != null) action!,
                ],
              ),
            ),
          Padding(
            padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: chart,
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: footer!,
            ),
        ],
      ),
    );
  }
}

/// Chart Tooltip Content - styled tooltip content matching shadcn-ui
class GrafitChartTooltipContent extends StatelessWidget {
  final String? title;
  final List<GrafitChartTooltipItem> items;
  final Color? backgroundColor;
  final Color? textColor;
  final GrafitChartTooltipIndicator indicator;
  final EdgeInsetsGeometry? padding;

  const GrafitChartTooltipContent({
    super.key,
    this.title,
    required this.items,
    this.backgroundColor,
    this.textColor,
    this.indicator = GrafitChartTooltipIndicator.dot,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final bg = backgroundColor ?? colors.popover;
    final text = textColor ?? colors.popoverForeground;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: text,
              ),
            ),
            const SizedBox(height: 6),
          ],
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: _buildTooltipItem(item, colors, text),
              )),
        ],
      ),
    );
  }

  Widget _buildTooltipItem(
    GrafitChartTooltipItem item,
    GrafitColorScheme colors,
    Color textColor,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIndicator(item.color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            item.label,
            style: TextStyle(
              fontSize: 11,
              color: colors.mutedForeground,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          item.value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textColor,
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

/// Trend indicator widget for showing up/down trends
class GrafitChartTrendIndicator extends StatelessWidget {
  final num value;
  final GrafitChartTrendDirection direction;
  final bool showPercentage;
  final String? label;
  final Color? upColor;
  final Color? downColor;
  final Color? neutralColor;

  const GrafitChartTrendIndicator({
    super.key,
    required this.value,
    required this.direction,
    this.showPercentage = true,
    this.label,
    this.upColor,
    this.downColor,
    this.neutralColor,
  });

  factory GrafitChartTrendIndicator.fromValues(
    num current,
    num previous, {
    bool showPercentage = true,
    String? label,
    Color? upColor,
    Color? downColor,
    Color? neutralColor,
  }) {
    final diff = current - previous;
    final percentage = previous != 0 ? (diff / previous * 100) : 0;

    GrafitChartTrendDirection direction;
    if (diff > 0) {
      direction = GrafitChartTrendDirection.up;
    } else if (diff < 0) {
      direction = GrafitChartTrendDirection.down;
    } else {
      direction = GrafitChartTrendDirection.neutral;
    }

    return GrafitChartTrendIndicator(
      value: showPercentage ? percentage : diff,
      direction: direction,
      showPercentage: showPercentage,
      label: label,
      upColor: upColor,
      downColor: downColor,
      neutralColor: neutralColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final effectiveUpColor = upColor ?? const Color(0xFF22c55e);
    final effectiveDownColor = downColor ?? const Color(0xFFef4444);
    final effectiveNeutralColor = neutralColor ?? colors.mutedForeground;

    Color effectiveColor;
    IconData icon;

    switch (direction) {
      case GrafitChartTrendDirection.up:
        effectiveColor = effectiveUpColor;
        icon = Icons.arrow_upward;
        break;
      case GrafitChartTrendDirection.down:
        effectiveColor = effectiveDownColor;
        icon = Icons.arrow_downward;
        break;
      case GrafitChartTrendDirection.neutral:
        effectiveColor = effectiveNeutralColor;
        icon = Icons.remove;
        break;
    }

    final valueText = showPercentage
        ? '${value.abs().toStringAsFixed(1)}%'
        : value.abs().toString();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 12,
              color: colors.mutedForeground,
            ),
          ),
          const SizedBox(width: 4),
        ],
        Icon(
          icon,
          size: 14,
          color: effectiveColor,
        ),
        const SizedBox(width: 2),
        Text(
          valueText,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: effectiveColor,
          ),
        ),
      ],
    );
  }
}

/// Stacked bar chart widget
class GrafitChartStackedBar extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String xKey;
  final List<String> yKeys;
  final String? colorKey;
  final String? title;
  final GrafitChartStackMode stackMode;
  final List<Color>? colors;

  const GrafitChartStackedBar({
    super.key,
    required this.data,
    required this.xKey,
    required this.yKeys,
    this.colorKey,
    this.title,
    this.stackMode = GrafitChartStackMode.stack,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitChart(
      data: data,
      type: GrafitChartType.stackedBar,
      xKey: xKey,
      yKeys: yKeys,
      colorKey: colorKey,
      title: title,
      stackMode: stackMode,
    );
  }
}

/// Grouped bar chart widget
class GrafitChartGroupedBar extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String xKey;
  final List<String> yKeys;
  final String? colorKey;
  final String? title;

  const GrafitChartGroupedBar({
    super.key,
    required this.data,
    required this.xKey,
    required this.yKeys,
    this.colorKey,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitChart(
      data: data,
      type: GrafitChartType.groupedBar,
      xKey: xKey,
      yKeys: yKeys,
      colorKey: colorKey,
      title: title,
    );
  }
}

/// Combo chart widget (bar + line combination)
class GrafitChartCombo extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String xKey;
  final List<String> yKeys;
  final GrafitChartType secondaryChartType;
  final String? title;

  const GrafitChartCombo({
    super.key,
    required this.data,
    required this.xKey,
    required this.yKeys,
    this.secondaryChartType = GrafitChartType.line,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GrafitChart(
      data: data,
      type: GrafitChartType.combo,
      xKey: xKey,
      yKeys: yKeys,
      secondaryChartType: secondaryChartType,
      title: title,
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Line Chart',
  type: GrafitChart,
  path: 'DataDisplay/Chart',
)
Widget chartLine(BuildContext context) {
  final data = [
    {'month': 'Jan', 'value': 65},
    {'month': 'Feb', 'value': 59},
    {'month': 'Mar', 'value': 80},
    {'month': 'Apr', 'value': 81},
    {'month': 'May', 'value': 56},
    {'month': 'Jun', 'value': 55},
    {'month': 'Jul', 'value': 40},
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitChart(
      data: data,
      type: GrafitChartType.line,
      xKey: 'month',
      yKeys: ['value'],
      title: 'Monthly Sales',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Area Chart',
  type: GrafitChart,
  path: 'DataDisplay/Chart',
)
Widget chartArea(BuildContext context) {
  final data = [
    {'month': 'Jan', 'value': 65},
    {'month': 'Feb', 'value': 59},
    {'month': 'Mar', 'value': 80},
    {'month': 'Apr', 'value': 81},
    {'month': 'May', 'value': 56},
    {'month': 'Jun', 'value': 55},
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitChart(
      data: data,
      type: GrafitChartType.area,
      xKey: 'month',
      yKeys: ['value'],
      title: 'Revenue Trend',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Bar Chart',
  type: GrafitChart,
  path: 'DataDisplay/Chart',
)
Widget chartBar(BuildContext context) {
  final data = [
    {'product': 'A', 'sales': 120},
    {'product': 'B', 'sales': 98},
    {'product': 'C', 'sales': 86},
    {'product': 'D', 'sales': 145},
    {'product': 'E', 'sales': 105},
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitChart(
      data: data,
      type: GrafitChartType.bar,
      xKey: 'product',
      yKeys: ['sales'],
      title: 'Sales by Product',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Pie Chart',
  type: GrafitChart,
  path: 'DataDisplay/Chart',
)
Widget chartPie(BuildContext context) {
  final data = [
    {'category': 'Electronics', 'value': 450},
    {'category': 'Clothing', 'value': 320},
    {'category': 'Food', 'value': 210},
    {'category': 'Other', 'value': 120},
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitChart(
      data: data,
      type: GrafitChartType.pie,
      xKey: 'category',
      yKeys: ['value'],
      colorKey: 'category',
      title: 'Sales by Category',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Donut Chart',
  type: GrafitChart,
  path: 'DataDisplay/Chart',
)
Widget chartDonut(BuildContext context) {
  final data = [
    {'category': 'Mobile', 'value': 55},
    {'category': 'Desktop', 'value': 30},
    {'category': 'Tablet', 'value': 15},
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitChart(
      data: data,
      type: GrafitChartType.donut,
      xKey: 'category',
      yKeys: ['value'],
      colorKey: 'category',
      title: 'Device Usage',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multi-Series Line',
  type: GrafitChart,
  path: 'DataDisplay/Chart',
)
Widget chartMultiSeriesLine(BuildContext context) {
  final data = [
    {'month': 'Jan', 'revenue': 65, 'expenses': 28},
    {'month': 'Feb', 'revenue': 59, 'expenses': 48},
    {'month': 'Mar', 'revenue': 80, 'expenses': 40},
    {'month': 'Apr', 'revenue': 81, 'expenses': 19},
    {'month': 'May', 'revenue': 56, 'expenses': 86},
    {'month': 'Jun', 'revenue': 55, 'expenses': 27},
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitChart(
      data: data,
      type: GrafitChartType.line,
      xKey: 'month',
      yKeys: ['revenue', 'expenses'],
      series: [
        GrafitChartSeries(key: 'revenue', label: 'Revenue'),
        GrafitChartSeries(key: 'expenses', label: 'Expenses'),
      ],
      title: 'Revenue vs Expenses',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Stacked Bar',
  type: GrafitChart,
  path: 'DataDisplay/Chart',
)
Widget chartStackedBar(BuildContext context) {
  final data = [
    {'quarter': 'Q1', 'productA': 30, 'productB': 20, 'productC': 15},
    {'quarter': 'Q2', 'productA': 45, 'productB': 25, 'productC': 20},
    {'quarter': 'Q3', 'productA': 60, 'productB': 35, 'productC': 25},
    {'quarter': 'Q4', 'productA': 75, 'productB': 40, 'productC': 30},
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitChart(
      data: data,
      type: GrafitChartType.stackedBar,
      xKey: 'quarter',
      yKeys: ['productA'],
      colorKey: 'quarter',
      title: 'Quarterly Sales',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Scatter Plot',
  type: GrafitChart,
  path: 'DataDisplay/Chart',
)
Widget chartScatter(BuildContext context) {
  final data = [
    {'x': 10, 'y': 20},
    {'x': 15, 'y': 25},
    {'x': 20, 'y': 15},
    {'x': 25, 'y': 30},
    {'x': 30, 'y': 35},
    {'x': 35, 'y': 28},
    {'x': 40, 'y': 40},
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitChart(
      data: data,
      type: GrafitChartType.scatter,
      xKey: 'x',
      yKeys: ['y'],
      title: 'Scatter Plot',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Sparkline',
  type: GrafitChart,
  path: 'DataDisplay/Chart',
)
Widget chartSparkline(BuildContext context) {
  final data = [
    {'value': 10},
    {'value': 15},
    {'value': 12},
    {'value': 18},
    {'value': 14},
    {'value': 20},
    {'value': 16},
    {'value': 22},
    {'value': 19},
    {'value': 25},
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: 300,
      child: GrafitChart(
        data: data,
        type: GrafitChartType.sparkline,
        xKey: 'value',
        yKeys: ['value'],
        height: 60,
        minimal: true,
        showLegend: false,
        showTooltip: false,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Combo Chart',
  type: GrafitChart,
  path: 'DataDisplay/Chart',
)
Widget chartCombo(BuildContext context) {
  final data = [
    {'month': 'Jan', 'sales': 65, 'target': 70},
    {'month': 'Feb', 'sales': 59, 'target': 65},
    {'month': 'Mar', 'sales': 80, 'target': 75},
    {'month': 'Apr', 'sales': 81, 'target': 80},
    {'month': 'May', 'sales': 56, 'target': 85},
    {'month': 'Jun', 'sales': 55, 'target': 90},
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitChart(
      data: data,
      type: GrafitChartType.combo,
      xKey: 'month',
      yKeys: ['sales', 'target'],
      title: 'Sales vs Target',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitChart,
  path: 'DataDisplay/Chart',
)
Widget chartInteractive(BuildContext context) {
  final chartType = context.knobs.list(
    label: 'Chart Type',
    initialOption: GrafitChartType.line,
    options: [
      GrafitChartType.line,
      GrafitChartType.area,
      GrafitChartType.bar,
      GrafitChartType.pie,
      GrafitChartType.donut,
      GrafitChartType.scatter,
    ],
  );

  final data = [
    {'month': 'Jan', 'value': 65},
    {'month': 'Feb', 'value': 59},
    {'month': 'Mar', 'value': 80},
    {'month': 'Apr', 'value': 81},
    {'month': 'May', 'value': 56},
    {'month': 'Jun', 'value': 55},
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitChart(
      data: data,
      type: chartType,
      xKey: 'month',
      yKeys: ['value'],
      title: 'Interactive Chart',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Chart Card',
  type: GrafitChartCard,
  path: 'DataDisplay/Chart',
)
Widget chartCard(BuildContext context) {
  final data = [
    {'month': 'Jan', 'value': 65},
    {'month': 'Feb', 'value': 59},
    {'month': 'Mar', 'value': 80},
    {'month': 'Apr', 'value': 81},
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitChartCard(
      title: 'Monthly Revenue',
      description: 'Total revenue for the current quarter',
      chart: GrafitChart(
        data: data,
        type: GrafitChartType.line,
        xKey: 'month',
        yKeys: ['value'],
      ),
      footer: Text(
        '\$${data.fold<int>(0, (sum, item) => sum + (item['value'] as int))} total',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
