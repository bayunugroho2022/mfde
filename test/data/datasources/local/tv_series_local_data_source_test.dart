import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/local/tv_local_data_source.dart';
import 'package:ditonton/presentation/resources/string_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TvLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('Add Watchlist', () {
    test('Should return success when insert in local database', () async {
      // arrange
      when(mockDatabaseHelper.insertTvWatchlist(testTVTable)).thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertTvWatchlist(testTVTable);
      // assert
      expect(result, StringManager.successWatchlist);
    });

    test('Should return failed when insert in local database', () async {
      // arrange
      when(mockDatabaseHelper.insertTvWatchlist(testTVTable)).thenThrow(Exception());
      // act
      final call = dataSource.insertTvWatchlist(testTVTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Remove Watchlist', () {
    test('Should return success when remove in local database', () async {
      // arrange
      when(mockDatabaseHelper.removeTvWatchlist(testTVTable)).thenAnswer((_) async => 1);
      // act
      final result =
          await dataSource.removeTvWatchlist(testTVTable);
      // assert
      expect(result, StringManager.failedConnect);
    });

    test('Should return failed when remove in local database', () async {
      // arrange
      when(mockDatabaseHelper.removeTvWatchlist(testTVTable)).thenThrow(Exception());
      // act
      final call = dataSource.removeTvWatchlist(testTVTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get detail TV by Id', () {

    test('Should return Detail TV when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTVById(1)).thenAnswer((_) async => testTVTable.toJson());
      // act
      final result = await dataSource.getTvById(1);
      // assert
      expect(result, testTVTable);
    });

    test('Should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTVById(1)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTvById(1);
      // assert
      expect(result, null);
    });
  });

  group('get all Watchlist TV Series', () {
    test('Should return list > 0 from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTv()).thenAnswer((_) async => [testTVTable.toJson()]);
      // act
      final result = await dataSource.getWatchlistTv();
      // assert
      expect(result.length, greaterThan(0));
    });
  });
}
