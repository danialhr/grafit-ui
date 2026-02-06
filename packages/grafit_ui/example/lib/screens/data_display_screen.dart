import 'package:flutter/material.dart';
import 'package:grafit_ui/grafit_ui.dart';

class DataDisplayScreen extends StatefulWidget {
  const DataDisplayScreen({super.key});

  @override
  State<DataDisplayScreen> createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
  int _currentPage = 0;
  final int _totalPages = 10;

  // Sample data for table
  final List<UserData> _users = List.generate(
    10,
    (index) => UserData(
      id: 'USR-${(index + 1).toString().padLeft(3, '0')}',
      name: ['Alice Johnson', 'Bob Smith', 'Carol White', 'David Brown', 'Eve Davis'][index % 5],
      email: 'user${index + 1}@example.com',
      status: ['Active', 'Inactive', 'Pending'][index % 3],
      role: ['Admin', 'User', 'Editor'][index % 3],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Scaffold(
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        backgroundColor: theme.colors.background,
        title: const Text('Data Display Components'),
        elevation: 0,
      ),
      body: GrafitScrollArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge Section
              _buildSectionHeader('Badge'),
              const SizedBox(height: 16),
              _buildBadgeSection(context, theme),
              const SizedBox(height: 32),

              // Avatar Section
              _buildSectionHeader('Avatar'),
              const SizedBox(height: 16),
              _buildAvatarSection(context, theme),
              const SizedBox(height: 32),

              // Data Table Section
              _buildSectionHeader('Data Table'),
              const SizedBox(height: 16),
              _buildDataTableSection(context, theme),
              const SizedBox(height: 32),

              // Pagination Section
              _buildSectionHeader('Pagination'),
              const SizedBox(height: 16),
              _buildPaginationSection(context, theme),
              const SizedBox(height: 32),

              // Chart Section
              _buildSectionHeader('Chart'),
              const SizedBox(height: 16),
              _buildChartSection(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return GrafitText.headlineSmall(title);
  }

  Widget _buildBadgeSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Badge Variants'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                const GrafitBadge(label: 'Primary', variant: GrafitBadgeVariant.primary),
                const GrafitBadge(label: 'Secondary', variant: GrafitBadgeVariant.secondary),
                const GrafitBadge(label: 'Outline', variant: GrafitBadgeVariant.outline),
                const GrafitBadge(label: 'Destructive', variant: GrafitBadgeVariant.destructive),
                const GrafitBadge(label: 'Ghost', variant: GrafitBadgeVariant.ghost),
                const GrafitBadge(label: 'Value', variant: GrafitBadgeVariant.value),
              ],
            ),
            const SizedBox(height: 24),
            GrafitText.titleMedium('Badge with Custom Colors'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                GrafitBadge(
                  label: 'Success',
                  backgroundColor: Colors.green.withOpacity(0.1),
                  foregroundColor: Colors.green,
                ),
                GrafitBadge(
                  label: 'Warning',
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  foregroundColor: Colors.orange,
                ),
                GrafitBadge(
                  label: 'Info',
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  foregroundColor: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Avatar Sizes'),
            const SizedBox(height: 16),
            Row(
              children: [
                GrafitAvatar(name: 'JD', size: 24),
                const SizedBox(width: 8),
                GrafitAvatar(name: 'JD', size: 32),
                const SizedBox(width: 8),
                GrafitAvatar(name: 'JD', size: 40),
                const SizedBox(width: 8),
                GrafitAvatar(name: 'JD', size: 48),
                const SizedBox(width: 8),
                GrafitAvatar(name: 'JD', size: 56),
              ],
            ),
            const SizedBox(height: 24),
            GrafitText.titleMedium('Avatar Variants'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                const GrafitAvatar(name: 'AB', size: 40),
                GrafitAvatar(
                  imageUrl: 'https://i.pravatar.cc/150?img=1',
                  size: 40,
                ),
                GrafitAvatar(
                  fallback: const Icon(Icons.person),
                  size: 40,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        const GrafitAvatar(name: 'JD', size: 40),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                BorderSide(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTableSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GrafitText.titleMedium('Users Table'),
                GrafitButton(
                  label: 'Export',
                  variant: GrafitButtonVariant.outline,
                  size: GrafitButtonSize.sm,
                  icon: Icons.download,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            GrafitDataTable<UserData>(
              data: _users,
              config: GrafitDataTableConfig<UserData>(
                columns: [
                  GrafitTableColumn<UserData>(
                    id: 'id',
                    label: 'ID',
                    cellBuilder: (context, user) => Text(user.id),
                    width: 100,
                  ),
                  GrafitTableColumn<UserData>(
                    id: 'name',
                    label: 'Name',
                    cellBuilder: (context, user) => Text(user.name),
                  ),
                  GrafitTableColumn<UserData>(
                    id: 'email',
                    label: 'Email',
                    cellBuilder: (context, user) => Text(user.email),
                  ),
                  GrafitTableColumn<UserData>(
                    id: 'role',
                    label: 'Role',
                    cellBuilder: (context, user) => Text(user.role),
                  ),
                  GrafitTableColumn<UserData>(
                    id: 'status',
                    label: 'Status',
                    cellBuilder: (context, user) => _buildStatusBadge(user.status),
                    sortable: false,
                  ),
                  GrafitTableColumn<UserData>(
                    id: 'actions',
                    label: 'Actions',
                    cellBuilder: (context, user) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GrafitButton(
                          variant: GrafitButtonVariant.ghost,
                          size: GrafitButtonSize.icon,
                          icon: Icons.edit_outlined,
                          onPressed: () {},
                        ),
                        GrafitButton(
                          variant: GrafitButtonVariant.ghost,
                          size: GrafitButtonSize.icon,
                          icon: Icons.delete_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    sortable: false,
                  ),
                ],
                selectionMode: GrafitTableSelectionMode.multiple,
                stripeRows: true,
                showBorders: true,
                hoverHighlight: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    switch (status) {
      case 'Active':
        return GrafitBadge(
          label: status,
          backgroundColor: Colors.green.withOpacity(0.1),
          foregroundColor: Colors.green,
        );
      case 'Inactive':
        return const GrafitBadge(label: status, variant: GrafitBadgeVariant.secondary);
      case 'Pending':
        return GrafitBadge(
          label: status,
          backgroundColor: Colors.orange.withOpacity(0.1),
          foregroundColor: Colors.orange,
        );
      default:
        return const GrafitBadge(label: status, variant: GrafitBadgeVariant.outline);
    }
  }

  Widget _buildPaginationSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Pagination'),
            const SizedBox(height: 16),
            GrafitPaginationWidget(
              currentPage: _currentPage,
              totalPages: _totalPages,
              onPageChanged: (page) => setState(() => _currentPage = page),
              showFirstLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(BuildContext context, GrafitTheme theme) {
    // Sample chart data
    final chartData = [
      {'month': 'Jan', 'revenue': 4500, 'expenses': 3200},
      {'month': 'Feb', 'revenue': 5200, 'expenses': 3800},
      {'month': 'Mar', 'revenue': 4800, 'expenses': 3500},
      {'month': 'Apr', 'revenue': 6100, 'expenses': 4200},
      {'month': 'May', 'revenue': 5900, 'expenses': 4000},
      {'month': 'Jun', 'revenue': 7200, 'expenses': 4800},
    ];

    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Revenue vs Expenses'),
            const SizedBox(height: 16),
            GrafitChartLine(
              data: chartData,
              xKey: 'month',
              yKey: 'revenue',
              color: theme.colors.primary,
              showPoints: true,
              showArea: true,
            ),
          ],
        ),
      ),
    );
  }
}

// Sample data class
class UserData {
  final String id;
  final String name;
  final String email;
  final String status;
  final String role;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.role,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserData && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
