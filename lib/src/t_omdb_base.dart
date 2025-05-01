// File imports
import './exceptions.dart';
// Library imports
import 'package:http/http.dart' as http;

enum OmdbResponseType { json, xml }

enum OmdbType { movie, series, episode }

enum OmdbPlot { short, full }

class OmdbApi {
  // Define the scheme, host and apiKey for the API to be used in the Uri
  final String scheme = 'https';
  final String host = 'omdbapi.com';
  final String apiKey;

  OmdbApi(this.apiKey);

  /// Searches for a movie by it's imdb id
  ///
  /// Example:
  ///
  /// ```
  /// final omdb = OmdbApi('your-api-key');
  /// final String? byId = await omdb.searchById('your-imdb-id-here');
  /// ```
  Future<String?> searchById(
    String id, {
    OmdbType? type,
    String? year,
    OmdbPlot? plot,
    OmdbResponseType? responseType,
    bool? tomatoes,
  }) async {
    final Map<String, dynamic> queryParameters = Map.fromEntries(
      [
        MapEntry('i', id),
        MapEntry('apikey', apiKey),
        MapEntry('type', type?.name),
        MapEntry('y', year),
        MapEntry('plot', plot?.name),
        MapEntry('r', responseType?.name),
        MapEntry('tomatoes', tomatoes?.toString()),
      ].where((element) => element.value != null),
    );

    final uri = Uri(
      scheme: scheme,
      host: host,
      queryParameters: queryParameters,
    );

    final response = handleOmdbHttpStatuses(await http.get(uri));

    print(response.statusCode);

    return response.body;
  }

  /// Searches for a movie by it's title and returns the first result
  ///
  /// Example:
  ///
  /// ```
  /// final omdb = OmdbApi('your-api-key');
  /// final String? byTitle = await omdb.searchByTitle('movie title here');
  /// ```
  Future<String?> searchByTitle(
    String title, {
    OmdbType? type,
    String? year,
    OmdbPlot? plot,
    OmdbResponseType? responseType,
  }) async {
    final Map<String, dynamic> queryParameters = Map.fromEntries(
      [
        MapEntry('t', title),
        MapEntry('apikey', apiKey),
        MapEntry('type', type?.name),
        MapEntry('y', year),
        MapEntry('plot', plot?.name),
        MapEntry('r', responseType?.name),
      ].where((element) => element.value != null),
    );

    final uri = Uri(
      scheme: scheme,
      host: host,
      queryParameters: queryParameters,
    );

    final response = handleOmdbHttpStatuses(await http.get(uri));

    return response.body;
  }

  /// Searches for a movie by a query and returns one or more results that match the query
  ///
  /// Example:
  ///
  /// ```
  /// final omdb = OmdbApi('your-api-key');
  /// final String? byQuery = await omdb.searchByQuery('movie title here');
  /// ```
  Future<String?> searchByQuery(
    String query, {
    OmdbType? type,
    String? year,
    OmdbResponseType? responseType,
    String? page,
  }) async {
    final Map<String, dynamic> queryParameters = Map.fromEntries(
      [
        MapEntry('s', query),
        MapEntry('apikey', apiKey),
        MapEntry('type', type?.name),
        MapEntry('y', year),
        MapEntry('r', responseType?.name),
        MapEntry('page', page),
      ].where((element) => element.value != null),
    );

    final uri = Uri(
      scheme: scheme,
      host: host,
      queryParameters: queryParameters,
    );

    final response = handleOmdbHttpStatuses(await http.get(uri));

    return response.body;
  }
}
