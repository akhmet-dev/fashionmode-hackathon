import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/avishu_motion.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AVISHU',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          'ПАНЕЛЬ АДМИНИСТРАТОРА',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AvishuPressable(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) context.go('/login');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.black),
                      ),
                      child: Text(
                        'ВЫЙТИ',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ПОЛЬЗОВАТЕЛИ',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: AppColors.black,
                    ),
                  ),
                  usersAsync.when(
                    data: (users) => Text(
                      '${users.length}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey,
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            // Users list
            Expanded(
              child: usersAsync.when(
                data: (users) => ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                  itemCount: users.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AppColors.divider),
                  itemBuilder: (context, i) {
                    final user = users[i];
                    return _UserTile(user: user);
                  },
                ),
                loading: () => const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.black,
                    ),
                  ),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'Ошибка: $e',
                    style: GoogleFonts.inter(color: AppColors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AvishuPressable(
        onTap: () => _showAddUserSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: AppColors.black,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, color: AppColors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'ДОБАВИТЬ',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddUserSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => const _AddUserSheet(),
    );
  }
}

// ── User Tile ───────────────────────────────────────────────────────────────

class _UserTile extends ConsumerWidget {
  final AppUser user;
  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final isSelf = currentUser?.uid == user.uid;

    return AvishuPressable(
      onTap: isSelf ? null : () => _showEditSheet(context, user),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 40,
              height: 40,
              color: AppColors.black,
              child: Center(
                child: Text(
                  user.name.isNotEmpty ? user.name[0] : '?',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _RoleBadge(role: user.role),
            if (!isSelf) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_sharp,
                size: 18,
                color: AppColors.grey,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context, AppUser user) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => _EditUserSheet(user: user),
    );
  }
}

// ── Role Badge ──────────────────────────────────────────────────────────────

class _RoleBadge extends StatelessWidget {
  final UserRole role;
  const _RoleBadge({required this.role});

  static const _labels = {
    UserRole.client: 'КЛИЕНТ',
    UserRole.franchisee: 'ФРАНЧАЙЗИ',
    UserRole.production: 'ЦЕХ',
    UserRole.admin: 'АДМИН',
  };

  static const _colors = {
    UserRole.client: Color(0xFFE8F5E9),
    UserRole.franchisee: Color(0xFFE3F2FD),
    UserRole.production: Color(0xFFFFF8E1),
    UserRole.admin: Color(0xFF000000),
  };

  static const _textColors = {
    UserRole.client: Color(0xFF2E7D32),
    UserRole.franchisee: Color(0xFF1565C0),
    UserRole.production: Color(0xFFF57F17),
    UserRole.admin: Color(0xFFFFFFFF),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: _colors[role],
      child: Text(
        _labels[role] ?? role.name.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: _textColors[role],
        ),
      ),
    );
  }
}

// ── Edit User Sheet ─────────────────────────────────────────────────────────

class _EditUserSheet extends ConsumerStatefulWidget {
  final AppUser user;
  const _EditUserSheet({required this.user});

  @override
  ConsumerState<_EditUserSheet> createState() => _EditUserSheetState();
}

class _EditUserSheetState extends ConsumerState<_EditUserSheet> {
  late UserRole _selectedRole;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.user.role;
  }

  Future<void> _save() async {
    if (_selectedRole == widget.user.role) {
      Navigator.pop(context);
      return;
    }
    setState(() => _loading = true);
    await ref
        .read(firestoreServiceProvider)
        .updateUserRole(widget.user.uid, _selectedRole);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(
          'УДАЛИТЬ?',
          style: GoogleFonts.inter(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        content: Text(
          '${widget.user.name} удалится из системы.',
          style: GoogleFonts.inter(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('ОТМЕНА', style: GoogleFonts.inter(color: AppColors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('УДАЛИТЬ', style: GoogleFonts.inter(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() => _loading = true);
    await ref
        .read(firestoreServiceProvider)
        .deleteUserDoc(widget.user.uid);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      widget.user.email,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              AvishuPressable(
                onTap: _loading ? null : _delete,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color(0xFFFFEBEE),
                  child: const Icon(
                    Icons.delete_outline_sharp,
                    size: 20,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 16),
          Text(
            'РОЛЬ',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 12),
          // Role selector
          ...UserRole.values.map((role) {
            final selected = _selectedRole == role;
            return AvishuPressable(
              onTap: () => setState(() => _selectedRole = role),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: selected ? AppColors.black : AppColors.lightGrey,
                  border: selected
                      ? null
                      : Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _roleLabel(role),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: selected ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
                    if (selected)
                      const Icon(Icons.check_sharp, color: AppColors.white, size: 18),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          AvishuPressable(
            onTap: _loading ? null : _save,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: AppColors.black,
              child: Center(
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        'СОХРАНИТЬ',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _roleLabel(UserRole role) => switch (role) {
    UserRole.client => 'КЛИЕНТ',
    UserRole.franchisee => 'ФРАНЧАЙЗИ',
    UserRole.production => 'ЦЕХ (ПРОИЗВОДСТВО)',
    UserRole.admin => 'АДМИНИСТРАТОР',
  };
}

// ── Add User Sheet ──────────────────────────────────────────────────────────

class _AddUserSheet extends ConsumerStatefulWidget {
  const _AddUserSheet();

  @override
  ConsumerState<_AddUserSheet> createState() => _AddUserSheetState();
}

class _AddUserSheetState extends ConsumerState<_AddUserSheet> {
  final _emailCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  UserRole _role = UserRole.client;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty || name.isEmpty || password.length < 6) {
      setState(() => _error = 'Заполните все поля (пароль мин. 6 символов)');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final err = await ref
        .read(firestoreServiceProvider)
        .createAppUser(
          email: email,
          name: name,
          role: _role,
          password: password,
        );

    if (!mounted) return;
    if (err != null) {
      setState(() {
        _loading = false;
        _error = err;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'НОВЫЙ ПОЛЬЗОВАТЕЛЬ',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 20),
          _buildField('ИМЯ', _nameCtrl, hint: 'IVAN IVANOV'),
          const SizedBox(height: 12),
          _buildField('EMAIL', _emailCtrl,
              hint: 'ivan@avishu.kz',
              inputType: TextInputType.emailAddress),
          const SizedBox(height: 12),
          _buildField('ПАРОЛЬ', _passwordCtrl,
              hint: 'мин. 6 символов', obscure: true),
          const SizedBox(height: 20),
          Text(
            'РОЛЬ',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: UserRole.values.map((role) {
              final selected = _role == role;
              return AvishuPressable(
                onTap: () => setState(() => _role = role),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  color: selected ? AppColors.black : AppColors.lightGrey,
                  child: Text(
                    _roleLabel(role),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: selected ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AvishuPressable(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: AppColors.lightGrey,
                    child: Center(
                      child: Text(
                        'ОТМЕНА',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AvishuPressable(
                  onTap: _loading ? null : _submit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: AppColors.black,
                    child: Center(
                      child: _loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : Text(
                              'СОЗДАТЬ',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    String hint = '',
    bool obscure = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          keyboardType: inputType,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  String _roleLabel(UserRole role) => switch (role) {
    UserRole.client => 'КЛИЕНТ',
    UserRole.franchisee => 'ФРАНЧАЙЗИ',
    UserRole.production => 'ЦЕХ',
    UserRole.admin => 'АДМИН',
  };
}
