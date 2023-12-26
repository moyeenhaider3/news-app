import 'package:app/domain/models/source.dart';
import 'package:app/presentation/blocs/filter/filter_cubit.dart';
import 'package:app/presentation/blocs/news_source/news_source_cubit.dart';
import 'package:app/presentation/blocs/search/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SourceSelectionDialog extends StatelessWidget {
  const SourceSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Set<Source> selectedSources = {};
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

            selectedSources = state.selected.toSet();
            return SingleChildScrollView(
              child: StatefulBuilder(builder: (context, setState) {
                return Column(
                  children: newSources.map((source) {
                    return CheckboxListTile(
                      key: Key(source.id!),
                      title: Text(source.name ?? "No-Name"),
                      value: selectedSources.contains(source),
                      onChanged: (bool? value) {
                        if (value != null) {
                          // Ensure value is not null before calling toggle
                          setState(() {
                            if (value) {
                              selectedSources.add(source);
                            } else {
                              selectedSources.remove(source);
                            }
                          });
                        }
                      },
                    );
                  }).toList(),
                );
              }),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            //while searching, fetching all the other parameters for search like: query, sortType

            context.read<NewsSourceCubit>().setSelectedSources(selectedSources);

            //selected type @default sortBy popularity
            final type = context.read<FilterCubit>().state.type;

            //searched query, if there's any
            String query = context.read<SearchCubit>().getSearchText();

            context.read<SearchCubit>().fetchFilteredResult(
                type: type, query: query, sources: selectedSources.toList());

            print('Selected Sources: $selectedSources');

            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
