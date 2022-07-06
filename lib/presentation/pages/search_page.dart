import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/widgets/card_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onSubmitted: (query) {
                  Provider.of<MovieSearchNotifier>(context, listen: false)
                      .fetchMovieSearch(query);
                },
                decoration: InputDecoration(
                  hintText: 'Search title',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.search,
              ),
              SizedBox(height: 16),
              Consumer<MovieSearchNotifier>(
                builder: (context, data, child) {
                  if (data.state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data.state == RequestState.Loaded) {
                    final result = data.searchResult;
                    final resultTv = data.tv;
                    return ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        Text(
                          'Movie',
                          style: kHeading6,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final movie = data.searchResult[index];
                            return CardItem(data: movie,);
                          },
                          itemCount: result.length,
                        ),
                        Text(
                          'Tv',
                          style: kHeading6,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final tv = data.tv[index];
                            return CardItem(data: tv,isTvSeries: true, );
                          },
                          itemCount: resultTv.length,
                        )
                      ],
                    );
                  } else {
                    return Expanded(
                      child: Container(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
