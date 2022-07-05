import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv_usecase.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_usecase.dart';
import 'package:ditonton/domain/usecases/tv/get_top_tv_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class TvSeriesListNotifier extends ChangeNotifier {
  //now playing
  var _nowPlayingTvSeries = <Tv>[];
  List<Tv> get nowPlayingTvSeries => _nowPlayingTvSeries;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  //popular
  var _popularTvSeries = <Tv>[];
  List<Tv> get popularTvSeries => _popularTvSeries;

  RequestState _popularTvSeriesState = RequestState.Empty;
  RequestState get popularTvSeriesState => _popularTvSeriesState;


  //top
  var _topRatedTvSeries = <Tv>[];
  List<Tv> get topRatedTvSeries => _topRatedTvSeries;

  RequestState _topRatedTvSeriesState = RequestState.Empty;
  RequestState get topRatedTvSeriesState => _topRatedTvSeriesState;

  String _message = '';
  String get message => _message;

  TvSeriesListNotifier({
    required this.getNowPlayingTvUseCase,
    required this.getPopularTvUseCase,
    required this.getTopTvUseCase,
  });

  final GetNowPlayingTvUseCase getNowPlayingTvUseCase;
  final GetPopularTvUseCase getPopularTvUseCase;
  final GetTopTvUseCase getTopTvUseCase;

  Future<void> fetchNowPlayingTvSeries() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTvUseCase.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.Error;
        _message = failure.message;
        print(message);
        notifyListeners();
      },
      (tvSeriesData) {
        _nowPlayingState = RequestState.Loaded;
        print(tvSeriesData.length.toString() + " bayu tes length ");
        _nowPlayingTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTv() async {
    _popularTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvUseCase.execute();
    result.fold(
          (failure) {
        _popularTvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvSeriesData) {
        _popularTvSeriesState = RequestState.Loaded;
        _popularTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopTv() async {
    _topRatedTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getTopTvUseCase.execute();
    result.fold(
          (failure) {
        _topRatedTvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvSeriesData) {
        _topRatedTvSeriesState = RequestState.Loaded;
        _topRatedTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
