import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// 🌐 ഇന്റർനെറ്റ് ഇല്ലാത്തപ്പോൾ കാണിക്കേണ്ട എറർ
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// 💾 ഫോണിന്റെ ലോക്കൽ മെമ്മറിയിൽ (Cache) നിന്ന് ഡാറ്റ എടുക്കാൻ പറ്റാത്ത അവസ്ഥ
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}