class Paths {
  static String movieImageUrl(String? posterPath) =>
      'https://image.tmdb.org/t/p/w500/$posterPath';

  static String movieCommentsPath(String movieId) => 'movies/$movieId/comments';
  static String favoritePath(String userId) => 'favorites/$userId/favorites';
}
