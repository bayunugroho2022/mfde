import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';

abstract class TvRepository {

  //tv home
  Future<Either<Failure, List<Tv>>> getNowPlayingTv();
  Future<Either<Failure, List<Tv>>> getPopularTv();
  Future<Either<Failure, List<Tv>>> getTopTv();

  //detail
  Future<Either<Failure, TvDetail>> getTvDetail(int id);
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id);

  //wishlist
  Future<Either<Failure, String>> saveWatchlist(TvDetail tvSeries);
  Future<Either<Failure, String>> removeWatchlist(TvDetail tvSeries);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTv();
}
