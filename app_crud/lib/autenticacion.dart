import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tarea/ver_equipos.dart';
import 'package:tarea/ver_usuarios.dart';

import 'crear_usuario.dart';

class Autenticacion extends StatefulWidget {
  const Autenticacion({Key? key});

  @override
  _AutenticacionState createState() => _AutenticacionState();
}

class _AutenticacionState extends State<Autenticacion> {
  String _email = '';
  String _password = '';
  String _userId = '';
  String _userName = '';

  void _handleLogin(GraphQLClient client) async {
    final mutation = gql("""
      mutation login(\$email: String!, \$password: String!) {
        login(loginInput: { email: \$email, password: \$password }) {
          token
          user {
            id
            name
          }
        }
      }
    """);

    final variables = {
      'email': _email,
      'password': _password,
    };

    final result = await client.mutate(
      MutationOptions(
        document: mutation,
        variables: variables,
      ),
    );

    // Print the entire result
    print('Mutation Result: $result');

    if (result.hasException) {
      print(result.exception.toString());
      // Handle the error
      return;
    }

    final token = result.data?['login']['token'];
    final user = result.data?['login']['user'];

    if (user != null) {
      setState(() {
        _userId = user['id'];
        _userName = user['name'];
      });

      // Navigate to UsersPage after successful login
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EquipPage(),
        ),
      );
    }

    // Handle the login response
    print('Token: $token');
    print('User: $user');
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLConsumer(
      builder: (GraphQLClient client) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Login Page'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _handleLogin(client),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16.0),
                if (_userId.isNotEmpty && _userName.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('User ID: $_userId'),
                      // Text('User Name: $_userName'),
                    ],
                  ),
                const SizedBox(height: 1.0),
                // Agrega un enlace para registrarse
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: Text(
                    '¿No tienes cuenta?',
                    style: TextStyle(
                      color: Color.fromARGB(255, 76, 29, 132),
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
}
