import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/molecules/paginated_data_table.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  group('Paginated Data Table Golden Tests', () {
    goldenTest(
      'DMPaginatedDataTable - Light Mode',
      fileName: 'paginated_data_table_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'paginated_data_table_light',
            child: SizedBox(width: 1200, height: 700, child: helper.createTestApp(_buildPaginatedDataTable())),
          ),
        ],
      ),
    );

    goldenTest(
      'DMPaginatedDataTable - Dark Mode',
      fileName: 'paginated_data_table_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'paginated_data_table_dark',
            child: SizedBox(
              width: 1200,
              height: 700,
              child: helper.createTestApp(_buildPaginatedDataTable(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'DMPaginatedDataTable - Empty State',
      fileName: 'paginated_data_table_empty',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'paginated_data_table_empty_light',
            child: SizedBox(width: 1200, height: 400, child: helper.createTestApp(_buildEmptyDataTable())),
          ),
        ],
      ),
    );

    goldenTest(
      'DMPaginatedDataTable - Loading State',
      fileName: 'paginated_data_table_loading',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'paginated_data_table_loading_light',
            child: SizedBox(width: 1200, height: 400, child: helper.createTestApp(_buildStaticLoadingDataTable())),
          ),
        ],
      ),
    );
  });
}

Widget _buildPaginatedDataTable() {
  return Material(
    child: Container(
      padding: const EdgeInsets.all(24),
      child: DMPaginatedDataTable(
        columns: const [
          DataTableColumn(key: 'email', label: 'Email', width: 2.5),
          DataTableColumn(key: 'name', label: 'Name', width: 1.5),
          DataTableColumn(key: 'role', label: 'Role', width: 1.5),
          DataTableColumn(key: 'joinDate', label: 'Join Date'),
          DataTableColumn(key: 'lastLogin', label: 'Last Login'),
        ],
        data: _getSampleData(),
        pageSize: 5,
        totalItems: _getSampleData().length,
        searchQuery: '',
        onPageChanged: (page) {},
        onSearchChanged: (query) {},
        rowBuilder: (user) => _buildUserRow(user),
      ),
    ),
  );
}

Widget _buildEmptyDataTable() {
  return Material(
    child: Container(
      padding: const EdgeInsets.all(24),
      child: DMPaginatedDataTable(
        columns: const [
          DataTableColumn(key: 'email', label: 'Email', width: 2.5),
          DataTableColumn(key: 'name', label: 'Name', width: 1.5),
          DataTableColumn(key: 'role', label: 'Role', width: 1.5),
          DataTableColumn(key: 'joinDate', label: 'Join Date'),
          DataTableColumn(key: 'lastLogin', label: 'Last Login'),
        ],
        data: const [],
        pageSize: 5,
        totalItems: 0,
        searchQuery: '',
        onPageChanged: (page) {},
        onSearchChanged: (query) {},
        rowBuilder: (user) => _buildUserRow(user),
      ),
    ),
  );
}

Widget _buildLoadingDataTable() {
  return Material(
    child: Container(
      padding: const EdgeInsets.all(24),
      child: DMPaginatedDataTable(
        columns: const [
          DataTableColumn(key: 'email', label: 'Email', width: 2.5),
          DataTableColumn(key: 'name', label: 'Name', width: 1.5),
          DataTableColumn(key: 'role', label: 'Role', width: 1.5),
          DataTableColumn(key: 'joinDate', label: 'Join Date'),
          DataTableColumn(key: 'lastLogin', label: 'Last Login'),
        ],
        data: const [],
        pageSize: 5,
        totalItems: 0,
        searchQuery: '',
        isLoading: true,
        onPageChanged: (page) {},
        onSearchChanged: (query) {},
        rowBuilder: (user) => _buildUserRow(user),
      ),
    ),
  );
}

Widget _buildStaticLoadingDataTable() {
  return Material(
    child: Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Loading data...', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    ),
  );
}

Widget _buildUserRow(Map<String, dynamic> user) {
  return SizedBox(
    height: 56,
    child: Row(
      children: [
        // Email
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              user['email'] ?? '',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // Name
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              user['name'] ?? '',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // Role
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              user['role'] ?? '',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // Join Date
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              user['joinDate'] ?? '',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // Last Login
        Expanded(
          flex: 2,
          child: Text(
            user['lastLogin'] ?? '',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

List<Map<String, dynamic>> _getSampleData() {
  return [
    {
      'id': '1',
      'email': 'user1@dmtools.com',
      'name': 'Alice Johnson',
      'role': 'Admin',
      'joinDate': '2024-01-15',
      'lastLogin': '2 hours ago',
    },
    {
      'id': '2',
      'email': 'user2@dmtools.com',
      'name': 'Bob Smith',
      'role': 'Regular User',
      'joinDate': '2024-02-03',
      'lastLogin': '1 day ago',
    },
    {
      'id': '3',
      'email': 'user3@dmtools.com',
      'name': 'Carol Davis',
      'role': 'Admin',
      'joinDate': '2024-01-28',
      'lastLogin': '5 minutes ago',
    },
  ];
}
