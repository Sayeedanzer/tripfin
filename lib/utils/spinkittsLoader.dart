
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Color_Constants.dart';

class Spinkits {
  Widget getSpinningLinespinkit() {
    return SizedBox(
      height: 20,
      width: 55,
      child: SpinKitSpinningLines(
        color: primary,
      ),
    );
  }
}

final spinkits = Spinkits();
