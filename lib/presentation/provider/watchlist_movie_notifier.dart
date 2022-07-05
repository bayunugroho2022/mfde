import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series_usecase.dart';
import 'package:flutter/foundation.dart';

class WatchlistNotifier extends ChangeNotifier {
  var _watchlistMovies = <Movie>[];
  List<Movie> get watchlistMovies => _watchlistMovies;

  var _watchlistTv = <Tv>[];
  List<Tv> get watchlistTv => _watchlistTv;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistNotifier(
      {required this.getWatchlistMovies, this.getWatchlistTv});

  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchlistTvUseCase? getWatchlistTv;

  Future<void> fetchWatchlistMovies() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final resultMovie = await getWatchlistMovies.execute();
    resultMovie.fold(
          (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (moviesData) {
        _watchlistState = RequestState.Loaded;
        _watchlistMovies = moviesData;
        notifyListeners();
      },
    );

    final resultTv = await getWatchlistTv?.execute();
    resultTv?.fold(
          (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvSeriesData) {
        _watchlistState = RequestState.Loaded;
        _watchlistTv = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
