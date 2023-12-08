import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DetalleReportePage extends StatefulWidget {
  final String reportId;

  DetalleReportePage({required this.reportId});

  @override
  _DetalleReportePageState createState() => _DetalleReportePageState();
}

class _DetalleReportePageState extends State<DetalleReportePage> {
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Reporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Report ID: ${widget.reportId}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Nueva Descripción'),
              onChanged: (value) {
                // Actualiza el valor de la descripción mientras el usuario escribe.
                // Puedes realizar validaciones u otras operaciones según sea necesario.
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Realiza la mutación de actualización de la descripción aquí
                await _performUpdateReportMutation(widget.reportId);
              },
              child: Text('Actualizar Descripción'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performUpdateReportMutation(String reportId) async {
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
        mutation updateReport(\$id: ID!, \$description: String!) {
          updateReport(updateReportInput: { id: \$id, description: \$description }) {
            error
            ok
            report {
              id
              description
              code
              equipment {
                name
                description
              }
              user {
                name
                lastName
              }
            }
          }
        }
      """),
      variables: {
        'id': reportId,
        'description': _descriptionController.text,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final error = result.data?['updateReport']['error'];
      final ok = result.data?['updateReport']['ok'];
      final report = result.data?['updateReport']['report'];

      print('Error: $error');
      print('OK: $ok');
      print('Report: $report');

      if (ok) {
        // Handle successful update
      }
    }
  }
}
