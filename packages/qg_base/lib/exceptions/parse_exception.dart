import 'package:qg_base/exceptions/exceptions.dart';

class ParseException extends BaseException {
  @override
  String get message => 'could not parse';
}
