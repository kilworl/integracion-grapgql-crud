import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tarea/ver_equipos.dart';
import 'delete_report.dart';
import 'detalles_reporte.dart';

class VerReportesPage extends StatefulWidget {
  @override
  _VerReportesPageState createState() => _VerReportesPageState();
}

class _VerReportesPageState extends State<VerReportesPage> {
  final HttpLink httpLink = HttpLink('http://localhost:3000/graphql');
  final AuthLink authLink = AuthLink(
    getToken: () async =>
        'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImI5Y2U5NjVhLTQxMDQtNDBlMS04OGQ4LTc5NzM0NWRiYzk1NCIsImlhdCI6MTcwMjAwMTE0MywiZXhwIjoxNzAyMDE1NTQzfQ.rqU2pFxDBF5lGVzNKO41irfPWYVOIefeJqjVExphjto', // Reemplaza con tu token real
  );
  late final Link link;

  _VerReportesPageState() {
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
          title: const Text('Reports Page'),
        ),
        body: Query(
          options: QueryOptions(
            document: gql("""
              query {
                getReports {
                  id
                  createdAt
                  updatedAt
                  deletedAt
                  code
                  description
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

            final reports = result.data?['getReports'];

            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                final equipment = report['equipment'];

                return ListTile(
                  title: Text('${report['code']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${report['id']}, ${report['description']}'),
                      Text(
                          'Equipment: ${equipment['name']} - ${equipment['description']}'),
                      Text('Created At: ${report['createdAt']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _navigateToDeleteReport(report['id']);
                    },
                  ),
                  onTap: () {
                    _navigateToDetalleReporte(report['id']);
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
                    title: const Text('Refresh Equipment?'),
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
                              builder: (context) => VerReportesPage(),
                            ),
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
                _navigateToEquip();
              },
              child: const Icon(Icons.arrow_back),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetalleReporte(String reportId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetalleReportePage(reportId: reportId),
      ),
    );
  }

  void _navigateToDeleteReport(String reportId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DeleteReportPage(reportId: reportId),
      ),
    );
  }

  void _navigateToEquip() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EquipPage(),
      ),
    );
  }
}
