import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv/tv_get_all_top_notifier.dart';
import 'package:ditonton/presentation/widgets/card_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-tv';

  @override
  _TopTvPageState createState() => _TopTvPageState();
}

class _TopTvPageState extends State<TopTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AllTopTvNotifier>(context, listen: false)
            .fetchTopRatedTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<AllTopTvNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = data.tvSeries[index];
                  return CardItem(
                    isTvSeries: true,
                    data: tvSeries,
                  );
                },
                itemCount: data.tvSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
