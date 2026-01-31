class ApiClient {
  const ApiClient();

  Future<Map<String, dynamic>> get(String endpoint) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return <String, dynamic>{
      'endpoint': endpoint,
      'status': 'ok',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
