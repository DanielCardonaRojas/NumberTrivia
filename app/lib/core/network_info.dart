import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:utilities/utilities.dart';

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;

  // Constructors
  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => this.connectionChecker.hasConnection;
}
