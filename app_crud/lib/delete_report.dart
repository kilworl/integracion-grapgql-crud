import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tarea/ver_equipos.dart'; // Asegúrate de importar el archivo correcto

class DeleteReportPage extends StatelessWidget {
  final String reportId;

  DeleteReportPage({required this.reportId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Reporte'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¿Estás seguro de que quieres eliminar este reporte?'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Realiza la mutación de eliminación de reporte aquí
                await _performRemoveReportMutation(context, reportId);
              },
              child: Text('Eliminar Reporte'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performRemoveReportMutation(
      BuildContext context, String reportId) async {
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
        mutation removeReport(\$id: ID!) {
          removeReport(id: \$id) {
            error
            ok
            report {
              id
            }
          }
        }
      """),
      variables: {
        'id': reportId,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final error = result.data?['removeReport']['error'];
      final ok = result.data?['removeReport']['ok'];
      final removedReportId = result.data?['removeReport']['report']['id'];

      print('Error: $error');
      print('OK: $ok');
      print('Removed Report ID: $removedReportId');

      if (ok) {
        // Handle successful removal, e.g., navigate back to EquipPage
        Navigator.pop(context); // Vuelve a la página anterior
      }
    }
  }
}
