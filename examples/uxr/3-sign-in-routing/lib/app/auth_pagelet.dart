import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class AuthPagelet extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final requestedRoute = context.navi.currentRoute;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'user',
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'user',
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        await _authService.login(
                          _usernameController.text,
                          _passwordController.text,
                        );

                        final authPath = context.navi.currentRoute.path;
                        if (_authService.authenticated &&
                            !requestedRoute.hasPrefixes(authPath)) {
                          context.navi.toRoute(requestedRoute);
                        }

                        if (!_authService.authenticated) {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Invalid username/password'),
                              content: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  children: const [
                                    Text('Correct username: user'),
                                    Text('Correct password: user'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ),
                const Text('Correct username: user'),
                const Text('Correct password: user'),
                const Text(
                  'Note: 3x slow motion to recognize page transition.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
