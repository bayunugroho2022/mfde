
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTopTvUseCase {
  final TvRepository repository;

  GetTopTvUseCase(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getTopTv();
  }
}
