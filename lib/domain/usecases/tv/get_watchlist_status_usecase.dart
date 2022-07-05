
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetWatchListStatusTvUseCase {
  final TvRepository repository;

  GetWatchListStatusTvUseCase(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
