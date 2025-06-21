import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../curved_edges/curved_edge_widget.dart';
import 'circular_container.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgeWidget(
      child: Container(
        color: TColors.primary,
          child: Stack(
            children: [
              // الدوائر الخلفية للزينة
              Positioned(top: -100, right: -100, child: TCircularContainer(width: 200, height: 200, radius: 200, backgroundColor: TColors.textWhite.withOpacity(0.1),),),
              Positioned(top: 100, right: -150, child: TCircularContainer(width: 300, height: 300, radius: 300, backgroundColor: TColors.textWhite.withOpacity(0.1),),),
              // المحتوى اللي هيتعرض داخل الـ Header
              child,
            ],
          ),
        ),

    );
  }
}
