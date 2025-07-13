import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contents/orders_content.dart';
import 'controllers/orders_cubit.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => OrdersCubit())],
      child: OrdersContent(),
    );
  }
}
