import 'package:flutter/material.dart';
import 'login_page.dart';
import 'api_service.dart'; // <-- make sure this file exists

class Homepage extends StatelessWidget {
  final Map user;
  const Homepage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MainLayout(user: user);
  }
}

enum RequestStatus { pending, approved, rejected }

class RequestItem {
  final String reqId;
  final String fileName;
  final String currentApprover;
  final RequestStatus status;
  final DateTime date;
  final String? rejectionReason;

  RequestItem({
    required this.reqId,
    required this.fileName,
    required this.currentApprover,
    required this.status,
    required this.date,
    this.rejectionReason,
  });
}

class NotificationItem {
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}

class UserProfile {
  final String name;
  final String email;
  final String department;
  final String employeeId;
  final String position;
  final String role;

  UserProfile({
    required this.name,
    required this.email,
    required this.department,
    required this.employeeId,
    required this.position,
    required this.role,
  });
}

// ---------------- MAIN LAYOUT ----------------

class MainLayout extends StatefulWidget {
  final Map user;
  const MainLayout({super.key, required this.user});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  bool _isMobile = false;

  late final List<Widget> _pages = [
    DashboardPage(user: widget.user),
    const NotificationsPage(),
    SettingsPage(user: widget.user),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    _isMobile = width < 800;

    return Scaffold(
      appBar: _isMobile
          ? AppBar(
              title: const Text('Employee Portal'),
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 1,
            )
          : null,
      drawer: _isMobile ? Drawer(child: _buildDrawerContent()) : null,
      body: Row(
        children: [
          if (!_isMobile)
            Container(
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
              ),
              child: _buildDrawerContent(),
            ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildDrawerContent() {
    final email = (widget.user['email'] ?? 'User').toString();
    final dept = (widget.user['dept_name'] ??
            widget.user['dept'] ??
            widget.user['department'] ??
            '')
        .toString();

    return Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Row(
            children: [
              Icon(
                Icons.account_circle,
                size: 48,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome',
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (dept.isNotEmpty)
                      Text(
                        dept,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.dashboard_outlined),
          title: const Text('Dashboard'),
          selected: _selectedIndex == 0,
          onTap: () {
            _onItemTapped(0);
            if (_isMobile) Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Notifications'),
          trailing: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
            child: const Text('3',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
          selected: _selectedIndex == 1,
          onTap: () {
            _onItemTapped(1);
            if (_isMobile) Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),
          selected: _selectedIndex == 2,
          onTap: () {
            _onItemTapped(2);
            if (_isMobile) Navigator.pop(context);
          },
        ),
        const Spacer(),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ---------------- DASHBOARD ----------------

class DashboardPage extends StatefulWidget {
  final Map user;
  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _filter = "All";
  late Future<List<RequestItem>> _futureRequests;

  @override
  void initState() {
    super.initState();
    _futureRequests = _loadRequests();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureRequests = _loadRequests();
    });
    await _futureRequests;
  }

  Future<List<RequestItem>> _loadRequests() async {
    // Needs Flask endpoint: /api/user_dashboard returning JSON with "all_request"
    final dash = await ApiService.fetchUserDashboard();
    final list = (dash["all_request"] as List?) ?? [];

    return list.map<RequestItem>((r) {
      final statusName =
          (r["status_name"] ?? "PENDING").toString().toUpperCase();

      final RequestStatus status;
      if (statusName == "APPROVED") {
        status = RequestStatus.approved;
      } else if (statusName == "REJECTED") {
        status = RequestStatus.rejected;
      } else {
        status = RequestStatus.pending;
      }

      final createdAtStr = (r["created_at"] ?? "").toString();
      final createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();

      final rejectionMsg = (r["rejection_message"] ?? "").toString().trim();

      return RequestItem(
        reqId: "REQ-${r["request_id"]}",
        fileName: (r["filename"] ?? "").toString(),
        currentApprover: (r["current_stage"] ?? "—").toString(),
        status: status,
        date: createdAt,
        rejectionReason: rejectionMsg.isEmpty ? null : rejectionMsg,
      );
    }).toList();
  }

  List<RequestItem> _applyFilter(List<RequestItem> all) {
    if (_filter == "All") return all;
    if (_filter == "Pending") {
      return all.where((r) => r.status == RequestStatus.pending).toList();
    }
    if (_filter == "Approved") {
      return all.where((r) => r.status == RequestStatus.approved).toList();
    }
    if (_filter == "Rejected") {
      return all.where((r) => r.status == RequestStatus.rejected).toList();
    }
    return all;
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.approved:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.pending:
        return Colors.orange;
    }
  }

  String _getStageDisplay(RequestItem request) {
    if (request.status == RequestStatus.approved) return "Request Complete";
    return request.currentApprover;
  }

  void _showRejectionReason(BuildContext context, String reason) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rejection Reason"),
        content: Text(reason),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dashboard",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Filters (unchanged design)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["All", "Pending", "Approved", "Rejected"]
                  .map((filterType) {
                final isSelected = _filter == filterType;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ChoiceChip(
                    label: Text(filterType),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _filter = filterType);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<RequestItem>>(
                future: _futureRequests,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return ListView(
                      children: [
                        const SizedBox(height: 120),
                        Center(child: Text("Failed to load: ${snap.error}")),
                      ],
                    );
                  }

                  final all = snap.data ?? [];
                  final filtered = _applyFilter(all);

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 700) {
                        return _buildMobileList(filtered);
                      } else {
                        return _buildDesktopTable(filtered);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // same UI, just uses "requests" list
  Widget _buildMobileList(List<RequestItem> requests) {
    if (requests.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 120),
          Center(child: Text("No requests found")),
        ],
      );
    }

    return ListView.separated(
      itemCount: requests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      request.reqId,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    _buildStatusBadge(request.status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.attach_file, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        request.fileName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.sync_alt, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Current Stage: ${_getStageDisplay(request)}",
                        style: TextStyle(color: Colors.grey.shade700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (request.status == RequestStatus.rejected &&
                    request.rejectionReason != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showRejectionReason(
                            context, request.rejectionReason!),
                        icon: const Icon(Icons.info_outline,
                            size: 16, color: Colors.red),
                        label: const Text("View Reason",
                            style: TextStyle(color: Colors.red)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopTable(List<RequestItem> requests) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
            columns: const [
              DataColumn(
                  label: Text('Req ID',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('File',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Status',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Current Stage',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Action',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: requests.map((request) {
              return DataRow(cells: [
                DataCell(Text(request.reqId,
                    style: const TextStyle(fontWeight: FontWeight.w500))),
                DataCell(Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.attach_file,
                        size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(request.fileName),
                  ],
                )),
                DataCell(_buildStatusBadge(request.status)),
                DataCell(Text(_getStageDisplay(request))),
                DataCell(
                  request.status == RequestStatus.rejected &&
                          request.rejectionReason != null
                      ? TextButton.icon(
                          icon: const Icon(Icons.info_outline,
                              size: 16, color: Colors.red),
                          label: const Text("Reason",
                              style: TextStyle(color: Colors.red)),
                          onPressed: () => _showRejectionReason(
                              context, request.rejectionReason!),
                        )
                      : const SizedBox.shrink(),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(RequestStatus status) {
    final c = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withOpacity(0.5)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: c,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ---------------- NOTIFICATIONS ----------------

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationItem>> _futureNotifs;

  @override
  void initState() {
    super.initState();
    _futureNotifs = _load();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureNotifs = _load();
    });
    await _futureNotifs;
  }

  Future<List<NotificationItem>> _load() async {
    final raw = await ApiService.fetchUserNotifications();

    return raw.map<NotificationItem>((n) {
      final title = (n["title"] ?? "Notification").toString();
      final message = (n["message"] ?? "").toString();

      // your backend returns string time; keep DateTime.now if you don't want parsing
      final dt = DateTime.now();

      return NotificationItem(title: title, message: message, time: dt);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notifications",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<NotificationItem>>(
                future: _futureNotifs,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return ListView(
                      children: [
                        const SizedBox(height: 120),
                        Center(child: Text("Failed to load: ${snap.error}")),
                      ],
                    );
                  }

                  final notifications = snap.data ?? [];
                  if (notifications.isEmpty) {
                    return ListView(
                      children: const [
                        SizedBox(height: 120),
                        Center(child: Text("No notifications")),
                      ],
                    );
                  }

                  // keep your list design
                  return ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (ctx, i) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return ListTile(
                        tileColor: Colors.white,
                        shape: index == 0
                            ? const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.vertical(top: Radius.circular(12)))
                            : index == notifications.length - 1
                                ? const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(12)))
                                : null,
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: Icon(Icons.notifications,
                              color: Colors.blue.shade700),
                        ),
                        title: Text(notif.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(notif.message),
                            const SizedBox(height: 4),
                            Text(
                              "${notif.time.day}/${notif.time.month} ${notif.time.hour}:${notif.time.minute.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- SETTINGS ----------------

class SettingsPage extends StatefulWidget {
  final Map user;
  const SettingsPage({super.key, required this.user});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final email = (widget.user['email'] ?? '').toString();
    final dept = (widget.user['dept_name'] ??
            widget.user['dept'] ??
            widget.user['department'] ??
            '')
        .toString();
    final position =
        (widget.user['position_name'] ?? widget.user['position'] ?? '')
            .toString();
    final role =
        (widget.user['role_name'] ?? widget.user['role'] ?? '').toString();
    final name = (widget.user['name'] ?? email).toString();

    final userProfile = UserProfile(
      name: name.isEmpty ? "User" : name,
      email: email.isEmpty ? "unknown@email" : email,
      department: dept.isEmpty ? "Unknown" : dept,
      employeeId: (widget.user['user_id'] ?? 'N/A').toString(),
      position: position.isEmpty ? "Unknown" : position,
      role: role.isEmpty ? "Unknown" : role,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Settings",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader("Personal Information"),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          userProfile.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProfile.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${userProfile.position} • ${userProfile.department}",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildInfoRow(Icons.badge, "User ID", userProfile.employeeId),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.email, "Email Address", userProfile.email),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.security, "Role", userProfile.role),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.business, "Department", userProfile.department),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          _buildSectionHeader("Preferences"),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Push Notifications"),
                  subtitle: const Text("Receive updates on request status"),
                  value: _notificationsEnabled,
                  onChanged: (val) => setState(() => _notificationsEnabled = val),
                  secondary: const Icon(Icons.notifications_active_outlined),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text("Dark Mode"),
                  subtitle: const Text("Switch application theme"),
                  value: _darkMode,
                  onChanged: (val) => setState(() => _darkMode = val),
                  secondary: const Icon(Icons.dark_mode_outlined),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile Request"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade500),
        const SizedBox(width: 16),
        SizedBox(
          width: 120,
          child: Text(label, style: TextStyle(color: Colors.grey.shade600)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}