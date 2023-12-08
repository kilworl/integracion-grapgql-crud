// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// class CrearEquipo extends StatefulWidget {
//   const CrearEquipo({Key? key}) : super(key: key);

//   @override
//   State<CrearEquipo> createState() => _CrearEquipoState();
// }

// class _CrearEquipoState extends State<CrearEquipo> {
//   final _formKey = GlobalKey<FormState>();
//   final _equipmentNameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _categoryController = TextEditingController();
//   final _stockController = TextEditingController();
//   final _imageUrlController = TextEditingController();

//   @override
//   void dispose() {
//     _equipmentNameController.dispose();
//     _descriptionController.dispose();
//     _categoryController.dispose();
//     _stockController.dispose();
//     _imageUrlController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _imageUrlController.text =
//         "https://www.google.com/url?sa=i&url=https%3A%2F%2Fbelltec.com.co%2Fmartillos%2F16986-martillo-con-mango-de-madera-cabeza-conica-stanley-51271.html&psig=AOvVaw05whIdG8X3A0Lzveh5YYP5&ust=1702008236377000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCLiWyfW4_IIDFQAAAAAdAAAAABAD"; // Default value for the image URL

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Crear Equipo'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 // Other TextFormField widgets can be added here
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16.0),
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (_formKey.currentState!.validate()) {
//                         await _performCreateEquipmentMutation();
//                       }
//                     },
//                     child: const Text('Create Equipment'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _performCreateEquipmentMutation() async {
//     final HttpLink httpLink = HttpLink(
//       'http://localhost:3000/graphql',
//       defaultHeaders: {
//         'Authorization':
//             'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjNlY2ZmZTcxLTFlNGYtNDJhMS05MGEwLTZhNWM1ZDhlY2ZkNCIsImlhdCI6MTcwMTkxNDU5OSwiZXhwIjoxNzAxOTI4OTk5fQ.vR8Lg-TFZWDKAxyP5RdlMV144rvpkTvbJvSjlKs1DmA', // Replace with your actual token
//       },
//     );

//     final GraphQLClient client = GraphQLClient(
//       cache: GraphQLCache(),
//       link: httpLink,
//     );

//     final MutationOptions options = MutationOptions(
//       document: gql("""
//         mutation createEquipment(
//           \$name: String!,
//           \$description: String!,
//           \$category: String!,
//           \$stock: Int!,
//           \$imageUrl: String!,
//         ) {
//           createEquipment(input: {
//             name: \$name,
//             description: \$description,
//             category: \$category,
//             stock: \$stock,
//             imageUrl: \$imageUrl,
//           }) {
//             error
//             ok
//             equipment {
//               id
//               createdAt
//               updatedAt
//               description
//               category
//               stock
//               imageUrl
//             }
//           }
//         }
//       """),
//       variables: {
//         'name': 'segundo equipment', // Use a TextFormField controller if needed
//         'description':
//             'esto es un equipo', // Use a TextFormField controller if needed
//         'category':
//             'segunda categoria', // Use a TextFormField controller if needed
//         'stock': 1, // Use a TextFormField controller if needed
//         'imageUrl': _imageUrlController
//             .text, // Use a TextFormField controller if needed
//       },
//     );

//     final QueryResult result = await client.mutate(options);

//     if (result.hasException) {
//       print(result.exception.toString());
//     } else {
//       final error = result.data?['createEquipment']['error'];
//       final ok = result.data?['createEquipment']['ok'];
//       final equipment = result.data?['createEquipment']['equipment'];

//       print('Error: $error');
//       print('OK: $ok');
//       print('Equipment: $equipment');

//       if (ok) {
//         // Handle successful creation
//       }
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// class CrearEquipo extends StatefulWidget {
//   const CrearEquipo({Key? key}) : super(key: key);

//   @override
//   State<CrearEquipo> createState() => _CrearEquipoState();
// }

// class _CrearEquipoState extends State<CrearEquipo> {
//   final _formKey = GlobalKey<FormState>();
//   final _equipmentNameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _categoryController = TextEditingController();
//   final _stockController = TextEditingController();
//   final _imageUrlController = TextEditingController();

//   @override
//   void dispose() {
//     _equipmentNameController.dispose();
//     _descriptionController.dispose();
//     _categoryController.dispose();
//     _stockController.dispose();
//     _imageUrlController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _equipmentNameController.text =
//         "segundo equipment"; // Default value for the equipment name

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Crear Equipo'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 TextFormField(
//                   controller: _equipmentNameController,
//                   decoration: const InputDecoration(labelText: 'Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the name of the equipment';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _descriptionController,
//                   decoration: const InputDecoration(labelText: 'Description'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a description';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _categoryController,
//                   decoration: const InputDecoration(labelText: 'Category'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a category';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _stockController,
//                   decoration: const InputDecoration(labelText: 'Stock'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a valid stock quantity';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _imageUrlController,
//                   decoration: const InputDecoration(labelText: 'Image URL'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter an image URL';
//                     }
//                     return null;
//                   },
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16.0),
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (_formKey.currentState!.validate()) {
//                         await _performCreateEquipmentMutation();
//                       }
//                     },
//                     child: const Text('Create Equipment'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _performCreateEquipmentMutation() async {
//     final HttpLink httpLink = HttpLink(
//       'http://localhost:3000/graphql',
//       defaultHeaders: {
//         'Authorization':
//             'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjJkNWQ4MjYyLThhZmItNDk4Yy1hNjQ0LWUxNzI5ODc3YWQxYSIsImlhdCI6MTcwMTkyOTU2OSwiZXhwIjoxNzAxOTQzOTY5fQ.za303XEkfMyLAkc7aX8tQ1cSWO-HcDfJdID1JLnpMQw', // Replace with your actual token
//       },
//     );

//     final GraphQLClient client = GraphQLClient(
//       cache: GraphQLCache(),
//       link: httpLink,
//     );

//     final MutationOptions options = MutationOptions(
//       document: gql("""
//         mutation createEquipment(
//           \$name: String!,
//           \$description: String!,
//           \$category: String!,
//           \$stock: Int!,
//           \$imageUrl: String!,
//         ) {
//           createEquipment(input: {
//             name: \$name,
//             description: \$description,
//             category: \$category,
//             stock: \$stock,
//             imageUrl: \$imageUrl,
//           }) {
//             error
//             ok
//             equipment {
//               id
//               createdAt
//               updatedAt
//               description
//               category
//               stock
//               imageUrl
//             }
//           }
//         }
//       """),
//       variables: {
//         'name': _equipmentNameController.text,
//         'description': _descriptionController.text,
//         'category': _categoryController.text,
//         'stock': int.tryParse(_stockController.text) ?? 0,
//         'imageUrl': _imageUrlController.text,
//       },
//     );

//     final QueryResult result = await client.mutate(options);

//     if (result.hasException) {
//       print(result.exception.toString());
//     } else {
//       final error = result.data?['createEquipment']['error'];
//       final ok = result.data?['createEquipment']['ok'];
//       final equipment = result.data?['createEquipment']['equipment'];

//       print('Error: $error');
//       print('OK: $ok');
//       print('Equipment: $equipment');

//       if (ok) {
//         // Handle successful creation
//       }
//     }
//   }
// }
// ----------
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tarea/ver_equipos.dart';

class CrearEquipo extends StatefulWidget {
  const CrearEquipo({Key? key}) : super(key: key);

  @override
  State<CrearEquipo> createState() => _CrearEquipoState();
}

class _CrearEquipoState extends State<CrearEquipo> {
  final _formKey = GlobalKey<FormState>();
  final _equipmentNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();

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
    // _equipmentNameController.text =
    //     "coloca el nombre"; // Default value for the equipment name

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Equipo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  onChanged: (value) {
                    // Actualiza el valor del nuevo nombre mientras el usuario escribe.
                    // Puedes realizar validaciones u otras operaciones según sea necesario.
                  },
                  controller: _equipmentNameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name of the equipment';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid stock quantity';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _performCreateEquipmentMutation();
                      }
                    },
                    child: const Text('Create Equipment'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _performCreateEquipmentMutation() async {
    final HttpLink httpLink = HttpLink(
      'http://localhost:3000/graphql',
      defaultHeaders: {
        'Authorization':
            'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImI5Y2U5NjVhLTQxMDQtNDBlMS04OGQ4LTc5NzM0NWRiYzk1NCIsImlhdCI6MTcwMjAwMTE0MywiZXhwIjoxNzAyMDE1NTQzfQ.rqU2pFxDBF5lGVzNKO41irfPWYVOIefeJqjVExphjto', // Replace with your actual token
      },
    );

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    final MutationOptions options = MutationOptions(
      document: gql("""
        mutation createEquipment(
          \$name: String!,
          \$description: String!,
          \$category: String!,
          \$stock: Int!,
          \$imageUrl: String!,
        ) {
          createEquipment(input: {
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
      variables: {
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
      final error = result.data?['createEquipment']['error'];
      final ok = result.data?['createEquipment']['ok'];
      final equipment = result.data?['createEquipment']['equipment'];

      print('Error: $error');
      print('OK: $ok');
      print('Equipment: $equipment');

      if (ok) {
        // Navigate to EquipPage() on successful creation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EquipPage()),
        );
      }
    }
  }
}
