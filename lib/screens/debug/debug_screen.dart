import 'package:flutter/material.dart';
import '../../services/app_database.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  final AppDatabase _database = AppDatabase.instance;
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _meals = [];
  List<Map<String, dynamic>> _nutritionLogs = [];
  List<Map<String, dynamic>> _workouts = [];
  bool _isLoading = true;
  String _selectedTable = 'users';

  @override
  void initState() {
    super.initState();
    _loadAllTables();
  }

  Future<void> _loadAllTables() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final db = await _database.database;

      // Load all tables
      final users = await db.query('users');
      final meals = await db.query('meals');
      final nutritionLogs = await db.query('nutrition_logs');
      final workouts = await db.query('workouts');

      setState(() {
        _users = users;
        _meals = meals;
        _nutritionLogs = nutritionLogs;
        _workouts = workouts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading tables: $e')));
      }
    }
  }

  List<Map<String, dynamic>> _getCurrentTableData() {
    switch (_selectedTable) {
      case 'users':
        return _users;
      case 'meals':
        return _meals;
      case 'nutrition_logs':
        return _nutritionLogs;
      case 'workouts':
        return _workouts;
      default:
        return [];
    }
  }

  String _getTableCount() {
    switch (_selectedTable) {
      case 'users':
        return '${_users.length}';
      case 'meals':
        return '${_meals.length}';
      case 'nutrition_logs':
        return '${_nutritionLogs.length}';
      case 'workouts':
        return '${_workouts.length}';
      default:
        return '0';
    }
  }

  Widget _buildTableSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Table:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildTableChip('users', 'Users'),
              _buildTableChip('meals', 'Meals'),
              _buildTableChip('nutrition_logs', 'Nutrition Logs'),
              _buildTableChip('workouts', 'Workouts'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Table: $_selectedTable (${_getTableCount()} records)',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTableChip(String tableName, String displayName) {
    final isSelected = _selectedTable == tableName;
    return FilterChip(
      label: Text(displayName),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedTable = tableName;
          });
        }
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildDataTable() {
    final data = _getCurrentTableData();

    if (data.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'No data found in this table',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // Get column names from the first row
    final columns = data.first.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns
            .map(
              (column) => DataColumn(
                label: Text(
                  column,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
            .toList(),
        rows: data
            .map(
              (row) => DataRow(
                cells: columns
                    .map(
                      (column) => DataCell(
                        Container(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            _formatCellValue(row[column]),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }

  String _formatCellValue(dynamic value) {
    if (value == null) return 'null';
    if (value is String && value.length > 100) {
      return '${value.substring(0, 100)}...';
    }
    return value.toString();
  }

  Widget _buildRawDataView() {
    final data = _getCurrentTableData();

    if (data.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'No data found in this table',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data
              .map(
                (row) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: row.entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: '${entry.key}: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: entry.value?.toString() ?? 'null',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Debug'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllTables,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildTableSelector(),
                const Divider(),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: 'Table View'),
                            Tab(text: 'Raw Data'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [_buildDataTable(), _buildRawDataView()],
                          ),
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
