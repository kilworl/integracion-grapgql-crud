import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const updateUserMutation = """
  mutation UpdateUser(\$input: UpdateUserInput!) {
    updateUser(input: \$input) {
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

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage(
      {Key? key,
      required this.userId,
      required this.userName,
      required String this.userLastname,
      required String this.userEmail})
      : super(key: key);

  final String userId;
  final String userName;
  final String userLastname;
  final String userEmail;

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
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
          title: const Text('Update User'),
        ),
        body: Mutation(
          options: MutationOptions(
            document: gql(updateUserMutation),
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
                    onChanged: (value) {
                      // Actualiza el valor del nuevo nombre mientras el usuario escribe.
                      // Puedes realizar validaciones u otras operaciones según sea necesario.
                    },
                    controller: _newNameController..text = widget.userName,
                    decoration: InputDecoration(
                      labelText: 'New Name',
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      // Actualiza el valor del nuevo nombre mientras el usuario escribe.
                      // Puedes realizar validaciones u otras operaciones según sea necesario.
                    },
                    controller: _userLastController..text = widget.userLastname,
                    decoration: InputDecoration(
                      labelText: 'New last name',
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      // Actualiza el valor del nuevo nombre mientras el usuario escribe.
                      // Puedes realizar validaciones u otras operaciones según sea necesario.
                    },
                    controller: _userEmaildController..text = widget.userEmail,
                    decoration: InputDecoration(
                      labelText: 'New email',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      runMutation({
                        "input": {
                          "id": _userIdController.text,
                          "lastName": _userLastController.text,
                          "name": _newNameController.text,
                          "email": _userEmaildController.text
                        }
                      });
                    },
                    child: const Text('Update User'),
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
