class QgFlutterStarterRuntimeConfig {
  final bool log;
  final bool secure;
  final bool respondWithPage;

  QgFlutterStarterRuntimeConfig({
    required this.log,
    required this.secure,
    this.respondWithPage = false,
  });
}
