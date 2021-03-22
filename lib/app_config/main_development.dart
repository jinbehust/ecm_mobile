import 'environment.dart';

void main() => Development();

class Development extends Environment {
  final String appName = "EcoECM";
  final String baseUrl = 'http://118.71.99.245:5038/api';
  EnvType environmentType = EnvType.DEVELOPMENT;
}
