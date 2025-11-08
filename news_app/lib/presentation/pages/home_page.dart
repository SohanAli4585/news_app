import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final List<String> categories = [
    "general",
    "business",
    "sports",
    "technology",
    "health",
    "science",
    "entertainment",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);

    final newsProvider = context.read<NewsProvider>();
    newsProvider.fetchNews(category: categories[0]);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !newsProvider.isLoading) {
        newsProvider.fetchNews(category: categories[_tabController.index]);
      }
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      newsProvider.changeCategory(categories[_tabController.index]);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.watch<NewsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Professional News App"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories
              .map((c) => Tab(text: c[0].toUpperCase() + c.substring(1)))
              .toList(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await newsProvider.fetchNews(
            category: categories[_tabController.index],
            refresh: true,
          );
        },
        child: newsProvider.articles.isEmpty && newsProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                controller: _scrollController,
                itemCount: newsProvider.articles.length + 1,
                itemBuilder: (context, index) {
                  if (index < newsProvider.articles.length) {
                    return NewsTile(article: newsProvider.articles[index]);
                  } else {
                    return newsProvider.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox();
                  }
                },
              ),
      ),
    );
  }
}
