import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CrearReportePage extends StatefulWidget {
  final String equipmentId;

  CrearReportePage({required this.equipmentId});

  @override
  _CrearReportePageState createState() => _CrearReportePageState();
}

class _CrearReportePageState extends State<CrearReportePage> {
  late TextEditingController _codeController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Reporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Código'),
              onChanged: (value) {},
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
              onChanged: (value) {},
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _performCreateReportMutation();
              },
              child: Text('Crear Reporte'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performCreateReportMutation() async {
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
        mutation createReport(
          \$code: String!,
          \$description: String!,
          \$equipmentId: String!,
          \$userId: String!,
        ) {
          createReport(input: {
            code: \$code,
            description: \$description,
            equipmentId: \$equipmentId,
            userId: \$userId,
          }) {
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
        'code': _codeController.text,
        'description': _descriptionController.text,
        'equipmentId': widget.equipmentId,
        'userId': 'b9ce965a-4104-40e1-88d8-797345dbc954',
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final error = result.data?['createReport']['error'];
      final ok = result.data?['createReport']['ok'];
      final report = result.data?['createReport']['report'];

      print('Error: $error');
      print('OK: $ok');
      print('Report: $report');

      if (ok) {
        // Handle successful report creation
      }
    }
  }
}
