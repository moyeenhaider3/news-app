import 'package:app/core/constraints/constraints.dart';
import 'package:app/domain/models/feed.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// {@template house_card}
/// A card with an image, title, subtitle, etc.
///
/// {@endtemplate}
class FeedCard extends StatelessWidget {
  /// {@macro house_card}
  const FeedCard({
    Key? key,
    required this.article,
    required this.onTap,
  }) : super(key: key);

  /// images url
  final Article article;

  /// a callback to be called when the card is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Card(
      color: Colors.grey.shade100,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(
            AppConstraints.large,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              article.urlToImage == null
                  ? const Placeholder(
                      child: SizedBox(
                      height: 150,
                    ))
                  : Image.network(article.urlToImage!),
              const Gap(AppConstraints.medium),
              Text(
                article.title.isEmpty ? "No Title" : article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.headlineSmall?.copyWith(
                  fontStyle: article.title.isEmpty ? FontStyle.italic : null,
                ),
              ),
              Text(
                article.description ?? "No Description",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyLarge?.copyWith(
                  color: const Color(0xffA4A4A4),
                ),
              ),
              const Gap(AppConstraints.medium),
              Wrap(
                spacing: AppConstraints.medium,
                runSpacing: AppConstraints.medium,
                children: [
                  Chip(
                    elevation: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: theme.colorScheme.tertiary,
                    label: Text(
                      article.source.name ?? "Source",
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onTertiary.withOpacity(0.5),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
