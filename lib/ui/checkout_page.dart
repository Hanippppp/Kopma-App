import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopma/bloc/user_bloc/user_bloc.dart';
import 'package:kopma/data/model/item/item_model.dart';

import '../bloc/detail_item_bloc/detail_item_bloc.dart';

class CheckoutPage extends StatefulWidget {
  final ItemModel item;

  const CheckoutPage({super.key, required this.item});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _quantity = 1;
  int _totalPrice = 1;

  void _incrementCounter() {
    setState(() {
      if (_quantity < widget.item.quantity) {
        _quantity += 1;
        _totalPrice = _quantity * widget.item.price;
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_quantity > 1) {
        _quantity -= 1;
        _totalPrice = _quantity * widget.item.price;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _totalPrice = widget.item.price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<DetailItemBloc, DetailItemState>(
        listener: (context, state) {
          if (state is BuyItemFailure) {
            showOkAlertDialog(
                context: context, title: "Error", message: state.errorMessage);
          } else if (state is BuyItemSuccess) {
            showOkAlertDialog(
                context: context,
                title: "Success",
                message: "Congrats! Your order is on its way!");
          }
        },
        child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.item.image,
                        width: 160,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Rp ${widget.item.price}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Card(
                            elevation: 4,
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: _decrementCounter,
                                  child: const Text("-"),
                                ),
                                Text(_quantity.toString()),
                                TextButton(
                                  onPressed: _incrementCounter,
                                  child: const Text("+"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Price",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Rp $_totalPrice',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              context.read<DetailItemBloc>().add(BuyItem(
                                itemId: widget.item.id!,
                                quantity: _quantity,
                              ));
                            });
                          },
                          child: Text("Pay Now",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}