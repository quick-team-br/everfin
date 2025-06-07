class ServiceResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  ServiceResponse.success(this.data) : success = true, error = null;

  ServiceResponse.failure(this.error) : success = false, data = null;
}
