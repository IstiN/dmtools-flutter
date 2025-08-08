import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class PaginatedDataTablePage extends StatefulWidget {
  const PaginatedDataTablePage({super.key});

  @override
  State<PaginatedDataTablePage> createState() => _PaginatedDataTablePageState();
}

class _PaginatedDataTablePageState extends State<PaginatedDataTablePage> {
  int _currentPage = 0;
  String? _searchQuery;
  bool _isLoading = false;
  late List<Map<String, dynamic>> _allUsers;

  @override
  void initState() {
    super.initState();
    _allUsers = _generateUsers();
  }

  List<Map<String, dynamic>> _generateUsers() {
    return List.generate(25, (index) {
      final id = index + 1;
      return {
        'id': id.toString(),
        'email': 'user$id@dmtools.com',
        'name': 'User Name $id',
        'role': id % 3 == 0 ? 'Admin' : 'Regular User',
        'joinDate': '2024-01-${(id % 30) + 1}',
        'lastLogin': '$id hours ago',
      };
    });
  }

  List<Map<String, dynamic>> get _filteredUsers {
    if (_searchQuery == null || _searchQuery!.isEmpty) {
      return _allUsers;
    }
    return _allUsers.where((user) {
      return user['email']!.toLowerCase().contains(_searchQuery!.toLowerCase()) ||
          user['name']!.toLowerCase().contains(_searchQuery!.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> get _currentPageData {
    const pageSize = 8;
    final startIndex = _currentPage * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, _filteredUsers.length);
    return _filteredUsers.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paginated Data Table')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppDimensions.spacingS,
              runSpacing: AppDimensions.spacingS,
              children: [
                SecondaryButton(
                  text: _isLoading ? 'Stop Loading' : 'Show Loading',
                  onPressed: () => setState(() => _isLoading = !_isLoading),
                  size: ButtonSize.small,
                ),
                SecondaryButton(
                  text: 'Clear Search',
                  onPressed: _searchQuery != null
                      ? () => setState(() {
                          _searchQuery = null;
                          _currentPage = 0;
                        })
                      : null,
                  size: ButtonSize.small,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingM),
            DMPaginatedDataTable(
              columns: const [
                DataTableColumn(key: 'email', label: 'Email', width: 2.5),
                DataTableColumn(key: 'name', label: 'Name', width: 1.5),
                DataTableColumn(key: 'role', label: 'Role', width: 1.5),
                DataTableColumn(key: 'joinDate', label: 'Join Date'),
                DataTableColumn(key: 'lastLogin', label: 'Last Login'),
              ],
              data: _currentPageData,
              totalItems: _filteredUsers.length,
              currentPage: _currentPage,
              pageSize: 8,
              isLoading: _isLoading,
              searchQuery: _searchQuery,
              onPageChanged: (page) => setState(() => _currentPage = page),
              onSearchChanged: (query) => setState(() {
                _searchQuery = query;
                _currentPage = 0;
              }),
              rowBuilder: (user) => _buildUserRow(user),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRow(Map<String, dynamic> user) {
    final colors = context.colorsListening;
    return SizedBox(
      height: 56, // Professional row height
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Email with proper styling
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user['email']!,
                      style: TextStyle(color: colors.textColor, fontSize: 14, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Name with styling
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user['name']!,
                      style: TextStyle(color: colors.textColor, fontSize: 14, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Role with improved dropdown
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  height: 36,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.inputBg,
                      border: Border.all(color: colors.borderColor.withValues(alpha: context.isDarkMode ? 0.3 : 0.6)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: user['role'],
                          onChanged: (newRole) {
                            if (newRole != null) {
                              setState(() {
                                final userIndex = _allUsers.indexWhere((u) => u['id'] == user['id']);
                                if (userIndex != -1) {
                                  _allUsers[userIndex]['role'] = newRole;
                                }
                              });
                            }
                          },
                          items: [
                            DropdownMenuItem(
                              value: 'Admin',
                              child: Text('Admin', style: TextStyle(fontSize: 13, color: colors.textColor)),
                            ),
                            DropdownMenuItem(
                              value: 'Regular User',
                              child: Text('Regular User', style: TextStyle(fontSize: 13, color: colors.textColor)),
                            ),
                          ],
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down, color: colors.textMuted, size: 18),
                          style: TextStyle(fontSize: 13, color: colors.textColor),
                          dropdownColor: colors.cardBg,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Join Date with styling
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user['joinDate']!,
                      style: TextStyle(color: colors.textSecondary, fontSize: 13, fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Last Login with styling
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user['lastLogin']!,
                    style: TextStyle(color: colors.textMuted, fontSize: 13, fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
