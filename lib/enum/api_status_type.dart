class ApiStatus<T> {
  ApiStatusType apiStatusType;
  T data;

  ApiStatus({this.apiStatusType = ApiStatusType.none, required this.data});
}

enum ApiStatusType { none, loading, error }
