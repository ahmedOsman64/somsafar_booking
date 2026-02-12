import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/models/user_model.dart';
import '../../shared/services/user_repository.dart';

class AdminCreateProviderScreen extends ConsumerStatefulWidget {
  final String? initialRole;
  const AdminCreateProviderScreen({super.key, this.initialRole});

  @override
  ConsumerState<AdminCreateProviderScreen> createState() =>
      _AdminCreateProviderScreenState();
}

class _AdminCreateProviderScreenState
    extends ConsumerState<AdminCreateProviderScreen> {
  final _formKey = GlobalKey<FormState>();

  // Role State
  late String _selectedRole;

  // Provider Info (Common)
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _providerCategory;
  AdminRole? _selectedAdminRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole ?? 'Provider';
  }

  // Account Info
  final _loginEmailController =
      TextEditingController(); // Could default to business email
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Status
  UserStatus _status = UserStatus.active;
  String _statusLabel = 'Verified'; // Pending, Verified, Suspended

  @override
  void dispose() {
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _loginEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _generatePassword() {
    // simple mock generator
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    _passwordController.text = "Prov${ts.length > 8 ? ts.substring(8) : ts}!";
    _confirmPasswordController.text = _passwordController.text;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Logic for creating account and adding to repository
      debugPrint(
        'Deploying $_selectedRole portal with status: $_status, category: $_providerCategory',
      );

      // Prepare fields
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      UserRole role = UserRole.provider;
      AdminRole? adminRole;
      ProviderType? providerType;

      if (_selectedRole == 'Admin') {
        role = UserRole.admin;
        adminRole = _selectedAdminRole;
      } else if (_selectedRole == 'Provider') {
        role = UserRole.provider;
        switch (_providerCategory) {
          case 'Home':
            providerType = ProviderType.home;
            break;
          case 'Apartment':
            providerType = ProviderType.apartment;
            break;
          case 'Hotel':
            providerType = ProviderType.hotel;
            break;
          case 'Vehicle':
            providerType = ProviderType.transport;
            break;
          default:
            providerType = null;
        }
      } else {
        role = UserRole.traveler;
      }

      final newUser = User(
        id: id,
        name: _ownerNameController.text.trim().isEmpty
            ? 'Unnamed $_selectedRole'
            : _ownerNameController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? '$id@example.com'
            : _emailController.text.trim(),
        role: role,
        adminRole: adminRole,
        providerType: providerType,
        status: _status,
        password: _passwordController.text,
      );

      // Add to repository so it appears in Manage Users
      ref.read(userProvider.notifier).addUser(newUser);

      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppColors.secondary,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'Successful Creation!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The $_selectedRole account has been successfully registered and is now active.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.pop(); // close dialog
                  context.pop(); // return to dashboard
                },
                child: const Text(
                  'Back to Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('New $_selectedRole Registration'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PORTAL SETUP',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create $_selectedRole Account',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Setup ${_selectedRole.toLowerCase()} profile and login credentials.',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      '1. Contact Information',
                      Icons.person_outline,
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey[200]!),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _ownerNameController,
                              label: _selectedRole == 'Provider'
                                  ? 'Owner Full Name *'
                                  : 'Full Name *',
                              prefixIcon: Icons.person_outline,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _emailController,
                              label: _selectedRole == 'Provider'
                                  ? 'Business Email *'
                                  : 'Email *',
                              inputType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _phoneController,
                              label: 'Phone Number *',
                              inputType: TextInputType.phone,
                              prefixIcon: Icons.phone_outlined,
                            ),
                            const SizedBox(height: 16),
                            if (_selectedRole == 'Provider')
                              DropdownButtonFormField<String>(
                                initialValue: _providerCategory,
                                decoration: InputDecoration(
                                  labelText: 'Provider Category *',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                items: ['Home', 'Apartment', 'Hotel', 'Vehicle']
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => _providerCategory = val),
                                validator: (val) {
                                  if (_selectedRole == 'Provider' &&
                                      (val == null || val.isEmpty)) {
                                    return 'Select category';
                                  }
                                  return null;
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader(
                      '2. System Login & Status',
                      Icons.security_outlined,
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey[200]!),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _loginEmailController,
                              label: 'Username / Portal ID *',
                              prefixIcon: Icons.alternate_email,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildPasswordField(
                                    controller: _passwordController,
                                    label: 'Temporary Password *',
                                    obscure: _obscurePassword,
                                    onToggle: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton.filled(
                                  onPressed: _generatePassword,
                                  icon: const Icon(Icons.refresh),
                                  style: IconButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                  ),
                                  tooltip: 'Generate Password',
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildPasswordField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password *',
                              obscure: _obscureConfirmPassword,
                              onToggle: () => setState(
                                () => _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      'Permission & Verification',
                      Icons.settings_suggest_outlined,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Portal Role',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'Provider',
                                label: Text('Provider'),
                                icon: Icon(Icons.store),
                              ),
                              ButtonSegment(
                                value: 'Admin',
                                label: Text('Admin'),
                                icon: Icon(Icons.admin_panel_settings),
                              ),
                            ],
                            selected: {_selectedRole},
                            onSelectionChanged: (Set<String> newSelection) {
                              setState(() {
                                _selectedRole = newSelection.first;
                                if (_selectedRole == 'Provider') {
                                  _selectedAdminRole = null;
                                }
                              });
                            },
                            style: SegmentedButton.styleFrom(
                              selectedBackgroundColor: AppColors.primary,
                              selectedForegroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Initial Status',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: _statusLabel,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          items: ['Pending', 'Verified', 'Suspended']
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _statusLabel = val;
                                if (val == 'Verified') {
                                  _status = UserStatus.active;
                                } else if (val == 'Suspended') {
                                  _status = UserStatus.suspended;
                                } else {
                                  // Pending or other
                                  _status = UserStatus.active;
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    if (_selectedRole == 'Admin') ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<AdminRole>(
                        initialValue: _selectedAdminRole,
                        decoration: const InputDecoration(
                          labelText: 'Admin Privileges',
                          border: OutlineInputBorder(),
                        ),
                        items: AdminRole.values
                            .map(
                              (ar) => DropdownMenuItem(
                                value: ar,
                                child: Text(ar.name),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedAdminRole = val),
                        validator: (val) => val == null ? 'Select level' : null,
                      ),
                    ],
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _submit,
                        child: Text(
                          'Create $_selectedRole & Activate',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, [IconData? icon]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? inputType,
    int maxLines = 1,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.primary)
            : null,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      keyboardType: inputType,
      maxLines: maxLines,
      validator: (val) {
        if (label.contains('*') && (val == null || val.isEmpty)) {
          return 'Required';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Required';
        }
        if (val.length < 8) {
          return 'Too short';
        }
        return null;
      },
    );
  }
}
