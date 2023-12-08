import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'crear_reporte.dart';

class DetallesEquipo extends StatefulWidget {
  final String equipmentId;
  final String initialEquipmentName;
  final String initialDescription;
  final String initialCategory;
  final int initialStock;
  final String initialImageUrl;

  DetallesEquipo({
    required this.equipmentId,
    required this.initialEquipmentName,
    required this.initialDescription,
    required this.initialCategory,
    required this.initialStock,
    required this.initialImageUrl,
  });

  @override
  _DetallesEquipoState createState() => _DetallesEquipoState();
}

class _DetallesEquipoState extends State<DetallesEquipo> {
  late TextEditingController _equipmentNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _stockController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _equipmentNameController =
        TextEditingController(text: widget.initialEquipmentName);
    _descriptionController =
        TextEditingController(text: widget.initialDescription);
    _categoryController = TextEditingController(text: widget.initialCategory);
    _stockController =
        TextEditingController(text: widget.initialStock.toString());
    _imageUrlController = TextEditingController(text: widget.initialImageUrl);
  }

  @override
  void dispose() {
    _equipmentNameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Equipo'),
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
            TextFormField(
              controller: _equipmentNameController,
              decoration: InputDecoration(labelText: 'Nombre del Equipo'),
              onChanged: (value) {
                // Actualiza el valor del nuevo nombre mientras el usuario escribe.
                // Puedes realizar validaciones u otras operaciones según sea necesario.
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
              onChanged: (value) {
                // Actualiza el valor de la descripción mientras el usuario escribe.
                // Puedes realizar validaciones u otras operaciones según sea necesario.
              },
            ),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Categoría'),
              onChanged: (value) {
                // Actualiza el valor de la categoría mientras el usuario escribe.
                // Puedes realizar validaciones u otras operaciones según sea necesario.
              },
            ),
            TextFormField(
              controller: _stockController,
              decoration: InputDecoration(labelText: 'Stock'),
              onChanged: (value) {
                // Actualiza el valor del stock mientras el usuario escribe.
                // Puedes realizar validaciones u otras operaciones según sea necesario.
              },
            ),
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'URL de la Imagen'),
              onChanged: (value) {
                // Actualiza el valor de la URL de la imagen mientras el usuario escribe.
                // Puedes realizar validaciones u otras operaciones según sea necesario.
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Realizar la mutación de actualización aquí
                await _performUpdateEquipmentMutation();
              },
              child: Text('Guardar Cambios'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _navigateToCrearReporte(widget.equipmentId);
              },
              child: Text('Crear Reporte'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCrearReporte(String equipmentId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CrearReportePage(equipmentId: equipmentId),
      ),
    );
  }

  Future<void> _performUpdateEquipmentMutation() async {
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
        mutation updateEquipment(
          \$id: ID!,
          \$name: String!,
          \$description: String!,
          \$category: String!,
          \$stock: Int!,
          \$imageUrl: String!,
        ) {
          updateEquipment(input: {
            id: \$id,
            name: \$name,
            description: \$description,
            category: \$category,
            stock: \$stock,
            imageUrl: \$imageUrl,
          }) {
            error
            ok
            equipment {
              id
              name
              description
              category
              stock
              imageUrl
            }
          }
        }
      """),
      variables: {
        'id': widget.equipmentId,
        'name': _equipmentNameController.text,
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'stock': int.tryParse(_stockController.text) ?? 0,
        'imageUrl': _imageUrlController.text,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final error = result.data?['updateEquipment']['error'];
      final ok = result.data?['updateEquipment']['ok'];
      final equipment = result.data?['updateEquipment']['equipment'];

      print('Error: $error');
      print('OK: $ok');
      print('Equipment: $equipment');

      if (ok) {
        // Handle successful update
      }
    }
  }
}
