import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tarea/user_delate.dart';

import 'package:tarea/user_details.dart';

import 'package:tarea/ver_equipos.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key});

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final HttpLink httpLink = HttpLink(
    'http://localhost:3000/graphql',
  );

  final AuthLink authLink = AuthLink(
    getToken: () async =>
        'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImI5Y2U5NjVhLTQxMDQtNDBlMS04OGQ4LTc5NzM0NWRiYzk1NCIsImlhdCI6MTcwMjAwMTE0MywiZXhwIjoxNzAyMDE1NTQzfQ.rqU2pFxDBF5lGVzNKO41irfPWYVOIefeJqjVExphjto',
  );

  late final Link link;

  @override
  void initState() {
    super.initState();

    link = authLink.concat(httpLink);
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Users Page'),
        ),
        body: Query(
          options: QueryOptions(
            document: gql("""
              query {
                getUsers {
                  id
                  name
                  lastName
                  email
                  password
                  role
                }
              }
            """),
          ),
          builder: (QueryResult result,
              {Refetch? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const CircularProgressIndicator();
            }

            final users = result.data?['getUsers'];

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text('${user['name']} ${user['lastName']}'),
                  subtitle: Text(
                      'Email: ${user['email']} | Role: ${user['role']}| ID: ${user['id']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _navigateToDeleteUser(
                          user['id'], user['name'], user['lastName']);
                    },
                  ),
                  onTap: () {
                    _navigateToUserDetails(user['id'], user['name'],
                        user['lastName'], user['email']);
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Refresh Users?'),
                    content: const Text('All data will be reloaded.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UsersPage()),
                          );
                        },
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.refresh),
            ),
            SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => EquipPage()),
                );
              },
              child: Icon(Icons.arrow_back),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToUserDetails(
      String userId, String userName, String userLastname, String userEmail) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(
            userId: userId,
            userName: userName,
            userLastname: userLastname,
            userEmail: userEmail),
      ),
    );
  }

  void _navigateToDeleteUser(
      String userId, String userName, String userLastname) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserDelete(
          userId: userId,
          userName: userName,
          userLastname: userLastname,
          userEmail: '',
        ),
      ),
    );
  }
}
