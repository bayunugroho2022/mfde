import 'package:ditonton/data/datasources/database_helper.dart';
import 'package:ditonton/data/datasources/local/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/remote/movie_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/tv/get_detail_tv_usecase.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_usecase.dart';
import 'package:ditonton/domain/usecases/tv/get_top_tv_usecase.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations_usecase.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_usecase.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series_usecase.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_usecase.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_usecase.dart';
import 'package:ditonton/presentation/provider/home_notifier.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_get_all_popular_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_get_all_top_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'data/datasources/local/tv_local_data_source.dart';
import 'data/datasources/remote/tv_remote_data_source.dart';
import 'domain/repositories/tv_repository.dart';
import 'domain/usecases/tv/get_now_playing_tv_usecase.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(() => MovieListNotifier(getNowPlayingMovies: locator(),getPopularMovies: locator(), getTopRatedMovies: locator(),),);
  locator.registerFactory(() => MovieDetailNotifier(getMovieDetail: locator(), getMovieRecommendations: locator(), getWatchListStatus: locator(), saveWatchlist: locator(), removeWatchlist: locator(),),);
  locator.registerFactory(() => MovieSearchNotifier(searchMovies: locator(),),);
  locator.registerFactory(() => PopularMoviesNotifier(locator(),),);
  locator.registerFactory(() => TopRatedMoviesNotifier(getTopRatedMovies: locator(),),);
  locator.registerFactory(() => WatchlistNotifier(getWatchlistMovies: locator(), getWatchlistTv: locator()),);
  locator.registerFactory(() => TvSeriesListNotifier(getNowPlayingTvUseCase: locator(), getPopularTvUseCase: locator(), getTopTvUseCase: locator(),),);
  locator.registerFactory(() => HomeNotifier());
  locator.registerFactory(() => AllTopTvNotifier(getTopTvUseCase: locator(),),);
  locator.registerFactory(() => AllPopularTvNotifier(getPopularTvUseCase: locator(),),);
  locator.registerFactory(() => TvDetailNotifier(getTvDetailUseCase: locator(), getTvSeriesRecommendationsUseCase: locator(), getWatchListStatusTvUseCase: locator(), saveWatchlistUseCase: locator(), removeWatchlistTvUseCase: locator(),),);

  // usecase
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetNowPlayingTvUseCase(locator()));
  locator.registerLazySingleton(() => GetPopularTvUseCase(locator()));
  locator.registerLazySingleton(() => GetTopTvUseCase(locator()));
  locator.registerLazySingleton(() => GetTvDetailUseCase(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendationsUseCase(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTvUseCase(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvUseCase(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvUseCase(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvUseCase(locator()));


  // repository
  locator.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(remoteDataSource: locator(),localDataSource: locator(),),);
  locator.registerLazySingleton<TvRepository>(() => TvRepositoryImpl(remoteDataSource: locator(), localDataSource: locator(),),);

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(() => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(() => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvRemoteDataSource>(() => TvSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(() => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
