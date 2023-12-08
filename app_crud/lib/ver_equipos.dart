import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tarea/ver_reporte.dart';
import 'package:tarea/ver_usuarios.dart';
import 'crear_equipo.dart';
import 'detalles_equipo.dart';
import 'delete_equipos.dart'; // Asegúrate de importar la página DeleteEquipos

class EquipPage extends StatelessWidget {
  final HttpLink httpLink = HttpLink('http://localhost:3000/graphql');
  final AuthLink authLink = AuthLink(
    getToken: () async =>
        'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImI5Y2U5NjVhLTQxMDQtNDBlMS04OGQ4LTc5NzM0NWRiYzk1NCIsImlhdCI6MTcwMjAwMTE0MywiZXhwIjoxNzAyMDE1NTQzfQ.rqU2pFxDBF5lGVzNKO41irfPWYVOIefeJqjVExphjto',
  );
  late final Link link;

  EquipPage() {
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
          title: const Text('Equipment Page'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrearEquipo()),
                );
              },
            ),
          ],
        ),
        body: Query(
          options: QueryOptions(
            document: gql("""
              query {
                getEquipments {
                  id
                  name
                  description
                  stock
                  category
                  imageUrl
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

            final equipments = result.data?['getEquipments'];

            return ListView.builder(
              itemCount: equipments.length,
              itemBuilder: (context, index) {
                final equipment = equipments[index];
                return ListTile(
                  title: Text('${equipment['name']}'),
                  subtitle: Text(
                      '${equipment['id']},${equipment['description']},${equipment['stock']},${equipment['category']}'),
                  leading: Image.network(
                    equipment['imageUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetallesEquipo(
                          equipmentId: equipment['id'],
                          initialEquipmentName: equipment['name'],
                          initialDescription: equipment['description'],
                          initialCategory: equipment['category'],
                          initialStock: equipment['stock'],
                          initialImageUrl: equipment['imageUrl'],
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeleteEquipos(
                            equipmentId: equipment['id'],
                          ),
                        ),
                      );
                    },
                  ),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UsersPage()),
                );
              },
              child: Icon(Icons.people),
            ),
            SizedBox(height: 16),
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
                              builder: (context) => EquipPage(),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => VerReportesPage()),
                );
              },
              child: Icon(Icons.report),
            ),
          ],
        ),
      ),
    );
  }
}
