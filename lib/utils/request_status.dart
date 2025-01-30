class RequestStatus<T> {
  final bool status;
  final String message;
  final T? data; // Optional data field of generic type T

  RequestStatus({required this.status, required this.message, this.data});

  factory RequestStatus.success([String message = "Success", T? data]) {
    return RequestStatus(status: true, message: message, data: data);
  }

  factory RequestStatus.failure(String message, [T? data]) {
    return RequestStatus(status: false, message: message, data: data);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestStatus &&
          other.status == status &&
          other.message == message &&
          other.data == data);

  @override
  int get hashCode => Object.hash(status, message, data);

  @override
  String toString() => 'RequestStatus(status: $status, message: $message, data: $data)';
}
