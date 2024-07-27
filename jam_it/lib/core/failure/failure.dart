// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppFailure {
  final String message;

  AppFailure({
    this.message = "Sorry, An Unexpected Error Occured",
  });

  @override
  String toString() => 'AppFailure(message: $message)';
}
