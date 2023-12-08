import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tarea/autenticacion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final HttpLink httpLink = HttpLink('http://localhost:3000/graphql');

  @override
  Widget build(BuildContext context) {
    try {
      final ValueNotifier<GraphQLClient> client = ValueNotifier(
        GraphQLClient(
          link: httpLink,
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

      return GraphQLProvider(
        client: client,
        child: MaterialApp(
          title: 'Material App',
          debugShowCheckedModeBanner: false,
          home: Autenticacion(),
        ),
      );
    } catch (error) {
      print('Error creating GraphQL client: $error');
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
                'Error creating GraphQL client. Check your server configuration.'),
          ),
        ),
      );
    }
  }
}
