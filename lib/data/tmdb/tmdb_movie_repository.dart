import 'package:dio/dio.dart';
import 'package:flix_id/data/repositories/movie_repository.dart';
import 'package:flix_id/domain/entities/actor.dart';
import 'package:flix_id/domain/entities/movie.dart';
import 'package:flix_id/domain/entities/movie_detail.dart';
import 'package:flix_id/domain/entities/result.dart';

class TmdbMovieRepository implements MovieRepository {
  final Dio? _dio;
  final String _accessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZGZiZTg1MmIxMmFiYzBlMWM0NDE4M2I2MmE5NzJkMiIsInN1YiI6IjU5NDI4ZmYzYzNhMzY4NmJlYjAwY2UyYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.51_F2hDDswuAU8LiDb1filyp0Nxs7prEz_o99k-Zr-A';

  late final Options _options = Options(
    headers: {
      'Authorization': 'Bearer $_accessToken',
      'accept': 'application/json',
    },
  );

  TmdbMovieRepository({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<Result<List<Actor>>> getActors({required int id}) async {
    try {
      final response = await _dio?.get(
        'https://api.themoviedb.org/3/movie/$id/credits?language=en-US',
        options: _options,
      );

      final results = List<Map<String, dynamic>>.from(
        response?.data['cast'] ?? response,
      );

      return Result.success(
        results
            .map(
              (e) => Actor.fromJSON(e),
            )
            .toList(),
      );
    } on DioException catch (e) {
      return Result.failed(e.message ?? '');
    }
  }

  @override
  Future<Result<MovieDetail>> getDetail({required int id}) async {
    try {
      final response = await _dio!.get(
        'https://api.themoviedb.org/3/movie/$id?language=en-US',
        options: _options,
      );

      return Result.success(
        MovieDetail.fromJSON(
          response.data,
        ),
      );
    } on DioException catch (e) {
      return Result.failed(e.message ?? '');
    }
  }

  @override
  Future<Result<List<Movie>>> getNowPlaying({
    int page = 1,
  }) async =>
      _getMovies(
        _MovieCategory.nowPlaying.toString(),
        page: page,
      );

  @override
  Future<Result<List<Movie>>> getUpComing({
    int page = 1,
  }) async =>
      _getMovies(
        _MovieCategory.upComing.toString(),
        page: page,
      );

  Future<Result<List<Movie>>> _getMovies(
    String category, {
    int page = 1,
  }) async {
    try {
      final response = await _dio?.get(
        'https://api.themoviedb.org/3/movie/$category?language=en-US&page=$page',
        options: _options,
      );

      final results = List<Map<String, dynamic>>.from(
        response?.data['results'],
      );

      return Result.success(
        results
            .map(
              (e) => Movie.fromJSON(e),
            )
            .toList(),
      );
    } on DioException catch (e) {
      return Result.failed(e.message ?? '');
    }
  }
}

enum _MovieCategory {
  nowPlaying('now_playing'),
  upComing('upcoming');

  final String _inString;

  const _MovieCategory(String inString) : _inString = inString;

  @override
  String toString() => _inString;
}
