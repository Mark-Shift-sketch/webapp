import 'package:flutter/material.dart';

void main() {
  runApp(const EmployeePortalApp());
}

class EmployeePortalApp extends StatelessWidget {
  const EmployeePortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      // Start at Login Page
      home: const LoginPage(),
    );
  }
}

// Auth Pages

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Mock delay
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() => _isLoading = false);
        // Navigate to Dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainLayout()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.account_circle, size: 80, color: Colors.blueAccent),
                  const SizedBox(height: 24),
                  Text(
                    "Welcome Back",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign in to continue to Employee Portal",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your email';
                      if (!value.contains('@')) return 'Please enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your password';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Login", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Colors.grey.shade600)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupPage()),
                          );
                        },
                        child: const Text("Sign Up"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedDept;
  
  final List<String> _departments = ['CTE', 'Finance', 'GSD'];

  bool _isLoading = false;

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Mock delay
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created! Please login.")),
        );
        Navigator.pop(context); // Go back to Login
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Join the company workspace",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => v!.isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) => !v!.contains('@') ? 'Invalid email' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedDept,
                    decoration: const InputDecoration(
                      labelText: "Department",
                      prefixIcon: Icon(Icons.business_outlined),
                    ),
                    items: _departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                    onChanged: (val) => setState(() => _selectedDept = val),
                    validator: (v) => v == null ? 'Select a department' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock_outlined),
                    ),
                    validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _handleSignup,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Sign Up", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

//Main Layout with Navigation 

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  bool _isMobile = false;

  final List<Widget> _pages = [
    const DashboardPage(),
    const NotificationsPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      drawer: _isMobile
          ? Drawer(
              child: _buildDrawerContent(),
            )
          : null,
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
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerContent() {
    return Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Row(
            children: [
              Icon(Icons.account_circle, size: 48, color: Theme.of(context).colorScheme.onPrimaryContainer),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Mark Arcanses',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
            child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 12)),
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
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Dashboard Page

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Mock Data
  final List<RequestItem> _allRequests = [
    RequestItem(reqId: "REQ-2024-001", fileName: "budget_report.pdf", currentApprover: "Manager A", status: RequestStatus.pending, date: DateTime.now().subtract(const Duration(days: 1))),
    RequestItem(reqId: "REQ-2024-002", fileName: "leave_form.docx", currentApprover: "HR Dept", status: RequestStatus.approved, date: DateTime.now().subtract(const Duration(days: 3))),
    RequestItem(reqId: "REQ-2024-003", fileName: "invoice_X99.png", currentApprover: "Finance Lead", status: RequestStatus.rejected, date: DateTime.now().subtract(const Duration(days: 5)), rejectionReason: "Invalid invoice formatting. Missing tax code."),
    RequestItem(reqId: "REQ-2024-004", fileName: "project_plan.pdf", currentApprover: "Manager B", status: RequestStatus.pending, date: DateTime.now()),
    RequestItem(reqId: "REQ-2024-005", fileName: "equipment_req.pdf", currentApprover: "IT Support", status: RequestStatus.approved, date: DateTime.now().subtract(const Duration(days: 10))),
  ];

  String _filter = "All";

  List<RequestItem> get _filteredRequests {
    if (_filter == "All") return _allRequests;
    if (_filter == "Pending") return _allRequests.where((r) => r.status == RequestStatus.pending).toList();
    if (_filter == "Approved") return _allRequests.where((r) => r.status == RequestStatus.approved).toList();
    if (_filter == "Rejected") return _allRequests.where((r) => r.status == RequestStatus.rejected).toList();
    return _allRequests;
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

  // Logic for displaying the stage
  String _getStageDisplay(RequestItem request) {
    if (request.status == RequestStatus.approved) {
      return "Request Complete";
    }
    // If pending, show approver. If rejected, it technically stops, but usually shows who rejected it.
    return request.currentApprover;
  }

  void _showRejectionReason(BuildContext context, String reason) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rejection Reason"),
        content: Text(reason),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))
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
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["All", "Pending", "Approved", "Rejected"].map((filterType) {
                final isSelected = _filter == filterType;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ChoiceChip(
                    label: Text(filterType),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          _filter = filterType;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Responsive Content
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 700) {
                  return _buildMobileList();
                } else {
                  return _buildDesktopTable();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList() {
    if (_filteredRequests.isEmpty) {
      return const Center(child: Text("No requests found"));
    }
    return ListView.separated(
      itemCount: _filteredRequests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final request = _filteredRequests[index];
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
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    _buildStatusBadge(request.status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.attach_file, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(child: Text(request.fileName, overflow: TextOverflow.ellipsis)),
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
                if (request.status == RequestStatus.rejected && request.rejectionReason != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showRejectionReason(context, request.rejectionReason!),
                        icon: const Icon(Icons.info_outline, size: 16, color: Colors.red),
                        label: const Text("View Reason", style: TextStyle(color: Colors.red)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopTable() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
            columns: const [
              DataColumn(label: Text('Req ID', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('File', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Current Stage', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: _filteredRequests.map((request) {
              return DataRow(cells: [
                DataCell(Text(request.reqId, style: const TextStyle(fontWeight: FontWeight.w500))),
                DataCell(Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.attach_file, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(request.fileName),
                  ],
                )),
                DataCell(_buildStatusBadge(request.status)),
                DataCell(Text(_getStageDisplay(request))),
                DataCell(
                  request.status == RequestStatus.rejected && request.rejectionReason != null
                  ? TextButton.icon(
                      icon: const Icon(Icons.info_outline, size: 16, color: Colors.red),
                      label: const Text("Reason", style: TextStyle(color: Colors.red)),
                      onPressed: () => _showRejectionReason(context, request.rejectionReason!),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getStatusColor(status).withOpacity(0.5)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Notifications Page

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //  Notifications
    final notifications = [
      NotificationItem(title: "Request Approved", message: "Your request REQ-2024-002 has been approved by HR.", time: DateTime.now().subtract(const Duration(minutes: 30))),
      NotificationItem(title: "New Policy Update", message: "Please review the updated employee handbook in the portal.", time: DateTime.now().subtract(const Duration(hours: 4))),
      NotificationItem(title: "Request Rejected", message: "Request REQ-2024-003 was rejected. Reason: Invalid format.", time: DateTime.now().subtract(const Duration(days: 1))),
      NotificationItem(title: "System Maintenance", message: "The portal will be down for maintenance on Sunday 2:00 AM.", time: DateTime.now().subtract(const Duration(days: 2))),
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notifications",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (ctx, i) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return ListTile(
                  tileColor: Colors.white,
                  shape: index == 0 
                    ? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))) 
                    : index == notifications.length - 1 
                      ? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)))
                      : null,
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(Icons.notifications, color: Colors.blue.shade700),
                  ),
                  title: Text(notif.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(notif.message),
                      const SizedBox(height: 4),
                      Text(
                        "${notif.time.day}/${notif.time.month} ${notif.time.hour}:${notif.time.minute}", 
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600)
                      ),
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Settings Page

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final UserProfile _user = UserProfile(
    name: "Mark Arcanses",
    email: "mark.coc@phinmaed.com",
    department: "CITE", 
    employeeId: "Student-001",     
    position: "Programmer",    
    role: "IT",         
  );

  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Settings",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          // Profile Card
          _buildSectionHeader("Personal Information"),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
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
                          _user.name.substring(0, 1),
                          style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("${_user.position} • ${_user.department}", style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildInfoRow(Icons.badge, "User ID", _user.employeeId),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.email, "Email Address", _user.email),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.security, "Role", _user.role),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.business, "Department", _user.department),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
          
          // App Settings
          _buildSectionHeader("Preferences"),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
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
          )
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