import 'package:app/presentation/blocs/filter/filter_cubit.dart';
import 'package:app/presentation/blocs/news_source/news_source_cubit.dart';
import 'package:app/presentation/blocs/search/search_cubit.dart';
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
            final type = context.read<FilterCubit>().state.type;
            String query = "";
            final searchCubit = context.read<SearchCubit>();
            if (searchCubit is SearchLoaded) {
              query = (searchCubit as SearchLoaded).searchText;
            }

            context
                .read<SearchCubit>()
                .onSearch(type: type, query: query, sources: selectedSources);
            print('Selected Sources: $selectedSources');
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
