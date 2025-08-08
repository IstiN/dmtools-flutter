import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

import '../network/generated/api.models.swagger.dart';
import '../network/generated/api.enums.swagger.dart' as enums;
import '../core/services/users_service.dart';

/// A simplified users table for the main app
class UsersTable extends StatefulWidget {
  final List<WorkspaceUserDto> users;
  final String searchQuery;
  final bool isLoading;
  final VoidCallback? onRefresh;
  final Function(String)? onSearchChanged;
  final Function(String)? onRemoveUser;
  final Function(String, enums.WorkspaceUserDtoRole)? onRoleChanged;

  const UsersTable({
    required this.users,
    this.searchQuery = '',
    this.isLoading = false,
    this.onRefresh,
    this.onSearchChanged,
    this.onRemoveUser,
    this.onRoleChanged,
    super.key,
  });

  @override
  State<UsersTable> createState() => _UsersTableState();
}

class _UsersTableState extends State<UsersTable> {
  late TextEditingController _searchController;
  int _currentPage = 0;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WorkspaceUserDto> get _filteredUsers {
    if (_searchController.text.isEmpty) {
      return widget.users;
    }

    final query = _searchController.text.toLowerCase();
    return widget.users.where((user) {
      final email = user.email?.toLowerCase() ?? '';
      final id = user.id?.toLowerCase() ?? '';
      return email.contains(query) || id.contains(query);
    }).toList();
  }

  List<WorkspaceUserDto> get _currentPageUsers {
    final filtered = _filteredUsers;
    final startIndex = _currentPage * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, filtered.length);
    return filtered.sublist(startIndex, endIndex);
  }

  int get _totalPages {
    return (_filteredUsers.length / _pageSize).ceil().clamp(1, double.infinity).toInt();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _currentPage = 0;
    });
    widget.onSearchChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBg,
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      style: TextStyle(color: colors.textColor, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search users by email or ID...',
                        hintStyle: TextStyle(color: colors.textMuted.withValues(alpha: 0.6)),
                        prefixIcon: Icon(Icons.search, color: colors.textMuted, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                                child: Icon(Icons.clear, color: colors.textMuted, size: 18),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.accentColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${_filteredUsers.length} users',
                  style: TextStyle(color: colors.textMuted, fontSize: 14),
                ),
              ],
            ),
          ),

          // Table Header
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.bgColor.withValues(alpha: 0.5),
              border: Border(
                top: BorderSide(color: colors.borderColor.withValues(alpha: 0.1)),
                bottom: BorderSide(color: colors.borderColor.withValues(alpha: 0.1)),
              ),
            ),
            child: SizedBox(
              height: 48,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        'EMAIL',
                        style: TextStyle(
                          color: colors.textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        'USER ID',
                        style: TextStyle(
                          color: colors.textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'ROLE',
                        style: TextStyle(
                          color: colors.textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'ACTIONS',
                        style: TextStyle(
                          color: colors.textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Table Body
          if (widget.isLoading)
            SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(color: colors.accentColor),
              ),
            )
          else if (_currentPageUsers.isEmpty)
            SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 48, color: colors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      'No users found',
                      style: TextStyle(color: colors.textMuted, fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._currentPageUsers.asMap().entries.map((entry) {
              final index = entry.key;
              final user = entry.value;
              final isLast = index == _currentPageUsers.length - 1;

              return DecoratedBox(
                decoration: BoxDecoration(
                  border: !isLast ? Border(bottom: BorderSide(color: colors.borderColor.withValues(alpha: 0.1))) : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    hoverColor: colors.textMuted.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: SizedBox(
                        height: 56,
                        child: Row(
                          children: [
                            // Email
                            Expanded(
                              flex: 5,
                              child: Text(
                                user.email ?? '',
                                style: TextStyle(
                                  color: colors.textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // User ID
                            Expanded(
                              flex: 4,
                              child: Text(
                                user.id ?? '',
                                style: TextStyle(
                                  color: colors.textSecondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Role
                            Expanded(
                              flex: 3,
                              child: widget.onRoleChanged != null
                                  ? SizedBox(
                                      height: 32,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: colors.borderColor.withValues(
                                              alpha: context.isDarkMode ? 0.3 : 0.6,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<enums.WorkspaceUserDtoRole>(
                                              value: user.role ?? enums.WorkspaceUserDtoRole.user,
                                              isDense: true,
                                              style: TextStyle(
                                                color: colors.textColor,
                                                fontSize: 13,
                                              ),
                                              dropdownColor: colors.cardBg,
                                              icon: Icon(
                                                Icons.expand_more,
                                                color: colors.textMuted,
                                                size: 16,
                                              ),
                                              items: const [
                                                DropdownMenuItem(
                                                  value: enums.WorkspaceUserDtoRole.user,
                                                  child: Text('User'),
                                                ),
                                                DropdownMenuItem(
                                                  value: enums.WorkspaceUserDtoRole.admin,
                                                  child: Text('Admin'),
                                                ),
                                              ],
                                              onChanged: (newRole) {
                                                if (newRole != null && newRole != user.role) {
                                                  widget.onRoleChanged?.call(user.id ?? '', newRole);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: UsersService.roleToDisplayString(user.role) == 'Admin'
                                            ? colors.accentColor.withValues(alpha: 0.1)
                                            : colors.textMuted.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Text(
                                          UsersService.roleToDisplayString(user.role),
                                          style: TextStyle(
                                            color: UsersService.roleToDisplayString(user.role) == 'Admin'
                                                ? colors.accentColor
                                                : colors.textMuted,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                            ),
                            // Actions
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => widget.onRemoveUser?.call(user.id ?? ''),
                                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                    tooltip: 'Remove user',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),

          // Pagination
          if (!widget.isLoading && _filteredUsers.isNotEmpty)
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colors.borderColor.withValues(alpha: 0.1))),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing ${_currentPage * _pageSize + 1}-${(_currentPage * _pageSize + _currentPageUsers.length)} of ${_filteredUsers.length}',
                      style: TextStyle(color: colors.textMuted, fontSize: 14),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                          icon: Icon(Icons.chevron_left, color: _currentPage > 0 ? colors.textColor : colors.textMuted),
                        ),
                        Text(
                          'Page ${_currentPage + 1} of $_totalPages',
                          style: TextStyle(color: colors.textColor, fontSize: 14),
                        ),
                        IconButton(
                          onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage++) : null,
                          icon: Icon(Icons.chevron_right,
                              color: _currentPage < _totalPages - 1 ? colors.textColor : colors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
