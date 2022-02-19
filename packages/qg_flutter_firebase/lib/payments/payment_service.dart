import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/repositories/base_repository.dart';
// import 'package:mad_pay/mad_pay.dart';

// https://developer.apple.com/documentation/passkit/apple_pay/setting_up_apple_pay_requirements
// https://developers.google.com/pay/api/android/overview

final Provider<PaymentRepository> pPaymentRepository =
    Provider<PaymentRepository>((ref) => PaymentRepository(ref.read));

class PaymentRepository extends BaseRepository {
  PaymentRepository(Reader read) : super(read);

  // final MadPay _madPay = MadPay();

  // Future<bool> paymentsAvailable() async {
  //   return _madPay.checkPayments();
  // }

  // Future<void> processPayment({
  //   required List<PaymentItem> paymentItems,
  //   List<PaymentNetwork>? paymentNetworks,
  //   String? countryCode,
  //   String? currencyCode,
  // }) async {
  //   await _madPay.processingPayment(
  //     google: GoogleParameters(
  //       gatewayName: 'gatewayName',
  //       gatewayMerchantId: 'gatewayMerchantId',
  //     ),
  //     apple: AppleParameters(
  //       merchantIdentifier: 'merchantIdentifier',
  //     ),
  //     currencyCode: currencyCode,
  //     countryCode: countryCode,
  //     paymentItems: paymentItems,
  //     paymentNetworks: paymentNetworks,
  //   );
  // }
}
