import 'package:app/core/constraints/constraints.dart';
import 'package:app/domain/models/article.dart';
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
          padding: const EdgeInsets.symmetric(
                  horizontal: AppConstraints.medium,
                  vertical: AppConstraints.large)
              .copyWith(top: AppConstraints.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstraints.medium),
                  topRight: Radius.circular(AppConstraints.medium),
                ),
                child: article.urlToImage == null
                    ? const Placeholder(
                        fallbackHeight: 150,
                        fallbackWidth: double.infinity,
                      )
                    : FadeInImage(
                        placeholder:
                            const AssetImage('assets/images/no-img.png'),
                        image: NetworkImage(article.urlToImage!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                      ),
              ),
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
