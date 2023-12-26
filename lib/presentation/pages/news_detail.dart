import 'package:app/core/constraints/constraints.dart';
import 'package:app/domain/models/article.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key, required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstraints.large)
              .copyWith(top: AppConstraints.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppConstraints.medium),
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
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: 150,
                      ),
              ),
              const Gap(AppConstraints.large),
              Text(
                article.title.isEmpty ? "No Title" : article.title,
                style: textTheme.headlineSmall?.copyWith(
                  fontStyle: article.title.isEmpty ? FontStyle.italic : null,
                ),
              ),
              const Gap(AppConstraints.large),
              Text(
                article.description ?? "No Description",
                style: textTheme.bodyLarge?.copyWith(
                  color: const Color(0xffA4A4A4),
                ),
              ),
              const Gap(AppConstraints.large),
              Text(
                article.content ?? "No Content",
                style: textTheme.bodyLarge?.copyWith(
                  color: const Color(0xffA4A4A4),
                ),
              ),
              const Gap(AppConstraints.medium),
              ExtraInfo(
                  title: "Author: ",
                  subtitle: article.author ?? "Unknown",
                  textTheme: textTheme),
              const Gap(AppConstraints.medium),
              ExtraInfo(
                  title: "Source: ",
                  subtitle: article.source.name ?? "Unknown",
                  textTheme: textTheme),
              const Gap(AppConstraints.medium),
              Text(
                "For more info visit:",
                style: textTheme.bodyLarge,
              ),
              Text(
                article.url,
                style: textTheme.bodyLarge?.copyWith(
                  color: const Color(0xffA4A4A4),
                ),
              ),
              const Gap(AppConstraints.medium)
            ],
          ),
        ),
      ),
    );
  }
}

class ExtraInfo extends StatelessWidget {
  const ExtraInfo({
    super.key,
    required this.title,
    required this.subtitle,
    required this.textTheme,
  });

  final String title;
  final String subtitle;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: textTheme.bodyLarge,
        ),
        Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyLarge?.copyWith(
            color: const Color(0xffA4A4A4),
          ),
        )
      ],
    );
  }
}
