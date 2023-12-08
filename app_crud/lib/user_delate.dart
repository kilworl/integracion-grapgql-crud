import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const removeUserMutation = """
  mutation RemoveUser(\$id: ID!) {
    removeUser(id: \$id) {
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
""";

class UserDelete extends StatefulWidget {
  const UserDelete({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userLastname,
    required this.userEmail,
  }) : super(key: key);

  final String userId;
  final String userName;
  final String userLastname;
  final String userEmail;

  @override
  _UserDeleteState createState() => _UserDeleteState();
}

class _UserDeleteState extends State<UserDelete> {
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

    link = AuthLink(
      getToken: () async =>
          'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImI5Y2U5NjVhLTQxMDQtNDBlMS04OGQ4LTc5NzM0NWRiYzk1NCIsImlhdCI6MTcwMjAwMTE0MywiZXhwIjoxNzAyMDE1NTQzfQ.rqU2pFxDBF5lGVzNKO41irfPWYVOIefeJqjVExphjto',
    ).concat(
      HttpLink('http://localhost:3000/graphql'),
    );
  }

  TextEditingController _userIdController = TextEditingController();
  TextEditingController _newNameController = TextEditingController();
  TextEditingController _userLastController = TextEditingController();
  TextEditingController _userEmaildController = TextEditingController();

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
          title: const Text('Remove User'),
        ),
        body: Mutation(
          options: MutationOptions(
            document: gql(removeUserMutation),
            onCompleted: (dynamic resultData) {
              // Puedes hacer algo con los datos del resultado aquí
            },
            onError: (OperationException? error) {
              // Maneja posibles errores aquí
            },
          ),
          builder: (
            RunMutation runMutation,
            QueryResult? result,
          ) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _userIdController..text = widget.userId,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'User ID',
                    ),
                  ),
                  TextField(
                    controller: _newNameController..text = widget.userName,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextField(
                    controller: _userLastController..text = widget.userLastname,
                    decoration: InputDecoration(
                      labelText: 'Last name',
                    ),
                  ),
                  TextField(
                    controller: _userEmaildController..text = widget.userEmail,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      runMutation({
                        "id": _userIdController.text,
                      });
                    },
                    child: const Text('Remove User'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
