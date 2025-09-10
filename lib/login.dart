import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';
import 'auth_service.dart';
import 'main_category.dart'; // add this import

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = true;
  bool _loading = false;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  String? _validateId(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter Staff ID or Email';
    final staffId = RegExp(r'^[A-Za-z]{2,5}\d{3,8}$');
    final email = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[A-Za-z]{2,}$');
    if (!(staffId.hasMatch(v) || email.hasMatch(v))) {
      return 'Enter a valid Staff ID (e.g., INV1234) or email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').isEmpty) return 'Please enter your password';
    if ((value ?? '').length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      // Simulate network a bit for UX
      await Future.delayed(const Duration(milliseconds: 500));

      final ok = await AuthService.instance.signIn(
        _idController.text,
        _pwController.text,
        remember: _rememberMe,
      );

      if (!ok) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid credentials')),
          );
        }
        return;
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CategoryPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 720;

            final card = Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 0,
                  color: cs.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(color: const Color(0xFFE3E6ED)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                    child: Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 44,
                                  width: 44,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [cs.primary, cs.primary.withOpacity(.7)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.inventory_2_rounded, color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Greenstem SPMS',
                                        style: TextStyle(
                                          color: cs.onSurface,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    Text('Inventory Staff Login',
                                        style: TextStyle(
                                          color: cs.onSurfaceVariant,
                                          fontSize: 13,
                                        )),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 20),

                            TextFormField(
                              controller: _idController,
                              autofillHints: const [AutofillHints.username, AutofillHints.email],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Staff ID or Email',
                                prefixIcon: Icon(Icons.badge_rounded),
                              ),
                              validator: _validateId,
                            ),
                            const SizedBox(height: 14),

                            TextFormField(
                              controller: _pwController,
                              autofillHints: const [AutofillHints.password],
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_rounded),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                  icon: Icon(_obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                                  tooltip: _obscure ? 'Show' : 'Hide',
                                ),
                              ),
                              validator: _validatePassword,
                              onFieldSubmitted: (_) => _signIn(),
                            ),
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) => setState(() => _rememberMe = v ?? true),
                                ),
                                const Text('Remember me'),
                              ],
                            ),
                            const SizedBox(height: 8),

                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: FilledButton(
                                onPressed: _loading ? null : _signIn,
                                child: _loading
                                    ? const SizedBox(
                                  width: 22, height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                                )
                                    : const Text('Sign In'),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cs.primary.withOpacity(0.08),
                          cs.primary.withOpacity(0.04),
                          Colors.transparent
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                if (isWide)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: _HeroBlurb(color: cs),
                      ),
                    ),
                  ),
                Align(
                  alignment: isWide ? Alignment.centerRight : Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(isWide ? 48 : 24),
                    child: card,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeroBlurb extends StatelessWidget {
  const _HeroBlurb({required this.color});
  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Spare Parts & Inventory',
            style: TextStyle(
              color: color.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            )),
        const SizedBox(height: 8),
        Text(
          'Check stock in real time, issue parts to work orders, and record returns or damaged items—right from your phone.',
          style: TextStyle(
            color: color.onSurfaceVariant,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
