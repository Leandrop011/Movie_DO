
abstract class MovieLastValueStorageService {
  
  Future<String> getValue( String key );

  Future<void> setValue( String key, String movieId );

}