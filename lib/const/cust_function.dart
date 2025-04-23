// import 'package:intl/intl.dart';
// import 'package:nb_utils/nb_utils.dart';

// class CustFunctions {
//    static Future<bool> checkConnection() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());

//     if (connectivityResult.first == ConnectivityResult.mobile) {
//       return true;
//     } else if (connectivityResult.first == ConnectivityResult.wifi) {
//       return true;
//     }
//     return false;
//   }

//     static String convertDate({required String date}) {
//     String dateInput = date;
//     DateTime parsedDate = DateTime.parse(dateInput);
//     String formattedDate = DateFormat('d MMMM yyyy').format(parsedDate);
//     return formattedDate;
//   }
// }
