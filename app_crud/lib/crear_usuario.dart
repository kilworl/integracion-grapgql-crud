import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tarea/ver_usuarios.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    hintText: 'Last Name',
                    labelText: 'Last Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last Name is required.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required.';
                    }
                    if (!RegExp(
                            r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required.';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _performCreateUserMutation();
                      }
                    },
                    child: const Text('Create User'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _performCreateUserMutation() async {
    final String name = _nameController.text;
    final String lastName = _lastNameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final MutationOptions options = MutationOptions(
      document: gql("""
        mutation CreateUser(\$name: String!, \$lastName: String!, \$email: String!, \$password: String!) {
          createUser(input: { name: \$name, lastName: \$lastName, email: \$email, password: \$password }) {
            error
            ok
            user {
              id
              name
              lastName
              email
              password
              role
            }
          }
        }
      """),
      variables: {
        'name': name,
        'lastName': lastName,
        'email': email,
        'password': password
      },
    );

    final QueryResult result =
        await GraphQLProvider.of(context).value.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final error = result.data?['createUser']['error'];
      final ok = result.data?['createUser']['ok'];
      final user = result.data?['createUser']['user'];

      print('Error: $error');
      print('OK: $ok');
      print('User: $user');

      if (ok) {
        // Navigate to UsersPage if user creation is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UsersPage()),
        );
      }
    }
  }
}
