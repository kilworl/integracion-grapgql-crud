import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DeleteEquipos extends StatefulWidget {
  final String equipmentId;

  DeleteEquipos({required this.equipmentId});

  @override
  _DeleteEquiposState createState() => _DeleteEquiposState();
}

class _DeleteEquiposState extends State<DeleteEquipos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Equipo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ID del Equipo: ${widget.equipmentId}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Realizar la mutación de eliminación aquí
                await _performRemoveEquipmentMutation();
              },
              child: Text('Eliminar Equipo'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performRemoveEquipmentMutation() async {
    final HttpLink httpLink = HttpLink(
      'http://localhost:3000/graphql',
      defaultHeaders: {
        'Authorization':
            'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImI5Y2U5NjVhLTQxMDQtNDBlMS04OGQ4LTc5NzM0NWRiYzk1NCIsImlhdCI6MTcwMjAwMTE0MywiZXhwIjoxNzAyMDE1NTQzfQ.rqU2pFxDBF5lGVzNKO41irfPWYVOIefeJqjVExphjto', // Reemplaza con tu token real
      },
    );

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    final MutationOptions options = MutationOptions(
      document: gql("""
        mutation removeEquipment(\$id: ID!) {
          removeEquipment(id: \$id) {
            error
            ok
            equipment {
              id
              createdAt
              updatedAt
              description
              category
              stock
              imageUrl
            }
          }
        }
      """),
      variables: {'id': widget.equipmentId},
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final error = result.data?['removeEquipment']['error'];
      final ok = result.data?['removeEquipment']['ok'];
      final equipment = result.data?['removeEquipment']['equipment'];

      print('Error: $error');
      print('OK: $ok');
      print('Equipment: $equipment');

      if (ok) {
        // Handle successful removal
      }
    }
  }
}
