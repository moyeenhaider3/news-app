import 'package:app/domain/models/feed.dart';
import 'package:app/domain/models/source.dart';
import 'package:app/presentation/blocs/filter/filter_cubit.dart';
import 'package:app/presentation/blocs/filter/filter_state.dart';
import 'package:app/presentation/blocs/news_source/news_source_cubit.dart';
import 'package:app/presentation/blocs/search/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectFilterDialog extends StatelessWidget {
  const SelectFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter News Sources'),
      content: BlocBuilder<FilterCubit, FilterState>(
        builder: (context, state) {
          final selectedSorting = state.type;
          return SingleChildScrollView(
            child: Column(children: [
              ListTile(
                title: const Text('Popularity'),
                leading: Radio<String>(
                  value: FilterTypes.popularity,
                  groupValue: selectedSorting,
                  onChanged: (value) {
                    if (value == null || value == selectedSorting) return;
                    context.read<FilterCubit>().updateType(value);
                  },
                ),
              ),
              ListTile(
                title: const Text('Relevance'),
                leading: Radio<String>(
                  value: FilterTypes.relevancy,
                  groupValue: selectedSorting,
                  onChanged: (value) {
                    if (value == null || value == selectedSorting) return;
                    context.read<FilterCubit>().updateType(value);
                  },
                ),
              ),
              ListTile(
                title: const Text('Latest'),
                leading: Radio<String>(
                  value: FilterTypes.publishedAt,
                  groupValue: selectedSorting,
                  onChanged: (value) {
                    if (value == null || value == selectedSorting) return;
                    context.read<FilterCubit>().updateType(value);
                  },
                ),
              ),
            ]),
          );
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
            //while searching, fetching all the other parameters for search like: sources, searched query
            final type = context.read<FilterCubit>().state.type;

            //searched query, if there's any

            String query = context.read<SearchCubit>().getSearchText();

            //selected sources, if there's any
            List<Source> sources =
                context.read<NewsSourceCubit>().getSelectedSources() ?? [];

            context.read<SearchCubit>().fetchFilteredResult(
                  type: type,
                  query: query,
                  sources: sources,
                );

            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
