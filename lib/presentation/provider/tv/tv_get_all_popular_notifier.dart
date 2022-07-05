import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_usecase.dart';
import 'package:flutter/foundation.dart';

class AllPopularTvNotifier extends ChangeNotifier {
  final GetPopularTvUseCase getPopularTvUseCase;

  AllPopularTvNotifier({required this.getPopularTvUseCase});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tv = [];
  List<Tv> get tv => _tv;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTv() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvUseCase.execute();

    result.fold(
          (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
          (data) {
        _tv = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
