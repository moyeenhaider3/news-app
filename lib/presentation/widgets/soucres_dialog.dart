import 'package:app/presentation/blocs/news_source/news_source_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SourceSelectionDialog extends StatelessWidget {
  const SourceSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select News Sources'),
      content: BlocBuilder<NewsSourceCubit, NewsSourceState>(
        builder: (context, state) {
          if (state is NewsSourceError) {
            return const Center(
              child: Text("Error loading sources"),
            );
          }
          if (state is NewsSourceLoaded) {
            final newSources = state.sources;
            final blc = context.watch<NewsSourceCubit>();
            return SingleChildScrollView(
              child: Column(
                children: newSources.map((source) {
                  return CheckboxListTile(
                    key: Key(source.id!),
                    title: Text(source.name ?? "No-Name"),
                    value: blc.isSourceSelected(source),
                    onChanged: (bool? value) {
                      if (value != null) {
                        // Ensure value is not null before calling toggle
                        blc.toggleSelectedSource(source);
                      }
                    },
                  );
                }).toList(),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final selectedSources =
                context.read<NewsSourceCubit>().getSelectedSources();
            // final selectedSources = blc.getSelectedSources();
            print('Selected Sources: $selectedSources');
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}



//?stateful
// import 'package:app/domain/models/feed.dart';
// import 'package:app/presentation/blocs/news_source/news_source_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SourceSelectionDialog extends StatefulWidget {
//   const SourceSelectionDialog({Key? key}) : super(key: key);

//   @override
//   _SourceSelectionDialogState createState() => _SourceSelectionDialogState();
// }

// class _SourceSelectionDialogState extends State<SourceSelectionDialog> {
//   List<Source> newSources = [];
//   Set<String> selectedSources = {};

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Select News Sources'),
//       content: BlocBuilder<NewsSourceCubit, NewsSourceState>(
//         builder: (context, state) {
//           if (state is NewsSourceLoaded) {
//             newSources = state.sources;

//             selectedSources = Set.of(state.selected.map((e) => e.id!));

//             return SingleChildScrollView(
//               child: Column(
//                 children: newSources.map((source) {
//                   return CheckboxListTile(
//                     title: Text(source.name ?? "No-Name"),
//                     value: selectedSources.contains(source.id),
//                     onChanged: (bool? value) {
//                       if (value != null) {
//                         setState(() {
//                           if (value) {
//                             selectedSources.add(source.id!);
//                           } else {
//                             selectedSources.remove(source.id);
//                           }
//                         });
//                       }
//                     },
//                   );
//                 }).toList(),
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(); // Close the dialog
//           },
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () {
//             // Handle the selected sources, for now, print them
//             print('Selected Sources: $selectedSources');
//             Navigator.of(context).pop(); // Close the dialog
//           },
//           child: const Text('Submit'),
//         ),
//       ],
//     );
//   }
// }




//?bloc cosumer

// import 'package:app/presentation/blocs/news_source/news_source_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SourceSelectionDialog extends StatelessWidget {
//   const SourceSelectionDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<NewsSourceCubit, NewsSourceState>(
//       listener: (context, state) {
//         if (state is NewsSourceLoaded) {
//           state.selected;
//         }
//       },
//       builder: (context, state) {
//         if (state is NewsSourceError) {
//           return const Center(
//             child: Text("Error loading sources"),
//           );
//         }
//         if (state is NewsSourceLoaded) {
//           final newSources = state.sources;
//           final blc = context.read<NewsSourceCubit>();
//           return AlertDialog(
//             title: const Text('Select News Sources'),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: newSources.map((source) {
//                   return CheckboxListTile(
//                     title: Text(source.name ?? "No-Name"),
//                     value: blc.isSourceSelected(source),
//                     onChanged: (bool? value) {
//                       if (value != null) {
//                         if (value) {
//                           print("Adding source: ${source.name}");
//                           blc.addSelectedSource(source);
//                         } else {
//                           print("Removing source: ${source.name}");
//                           blc.removeSelectedSource(source);
//                         }
//                       }
//                     },
//                   );
//                 }).toList(),
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   final selectedSources = blc.getSelectedSources();
//                   print('Selected Sources: $selectedSources');
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: const Text('Submit'),
//               ),
//             ],
//           );
//         }
//         return const SizedBox.shrink();
//       },
//     );
//   }
// }
