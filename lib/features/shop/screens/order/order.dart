import 'package:flutter/material.dart';
import 'package:t_store/features/shop/screens/order/widgets/orders_list.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';

// Convert OrderScreen to a StatefulWidget
class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _appBarFadeAnimation;
  late Animation<Offset> _orderListSlideAnimation;
  late Animation<double> _orderListFadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // Adjust duration as needed
    );

    // AppBar Fade Animation
    _appBarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Order List Slide and Fade Animation
    _orderListSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05), // Start slightly below
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _orderListFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// --- AppBar
      appBar: TAppBar(
        showBackArrow: true,
        title: FadeTransition(
          opacity: _appBarFadeAnimation,
          child: Text('My Orders', style: Theme.of(context).textTheme.headlineSmall),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SlideTransition(
          position: _orderListSlideAnimation,
          child: FadeTransition(
            opacity: _orderListFadeAnimation,
            child: const TOrderListItems(), // This widget will be animated as a whole
          ),
        ),
      ),
    );
  }
}

