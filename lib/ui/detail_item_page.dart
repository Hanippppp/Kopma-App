import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopma/bloc/detail_item_bloc/detail_item_bloc.dart';
import 'package:kopma/data/model/item/item_model.dart';

import 'checkout_page.dart';

class DetailItemPage extends StatefulWidget {
  final String idItem;

  const DetailItemPage({super.key, required this.idItem});

  @override
  State<DetailItemPage> createState() => _DetailItemPageState();
}

class _DetailItemPageState extends State<DetailItemPage> {
  @override
  void initState() {
    super.initState();
    context.read<DetailItemBloc>().add(GetDetailItem(itemId: widget.idItem));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<DetailItemBloc, DetailItemState>(
        listener: (context, state) {
          if (state == const DetailItemState.empty()) {
            const Text("No Data");
          }
          if (state is AddItemToCartFailure) {
            showOkAlertDialog(
                context: context, title: "Error", message: state.errorMessage);
            context.read<DetailItemBloc>().add(GetDetailItem(itemId: widget.idItem));
          } else if (state is AddItemToCartSuccess) {
            showOkAlertDialog(
                context: context,
                title: "Success",
                message:
                "Nailed it! ${state.item?.name} is chilling in your cart.");
            context.read<DetailItemBloc>().add(GetDetailItem(itemId: widget.idItem));
          } else if(state is BuyItemSuccess) {
            context.read<DetailItemBloc>().add(GetDetailItem(itemId: widget.idItem));
          } else if(state is BuyItemFailure) {
            context.read<DetailItemBloc>().add(GetDetailItem(itemId: widget.idItem));
          }
        },
        child: BlocBuilder<DetailItemBloc, DetailItemState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CachedNetworkImage(
                                imageUrl: state.item?.image ?? "",
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                state.item?.name ?? "",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                state.item?.price != null
                                    ? '\$${state.item!.price.toStringAsFixed(2)}'
                                    : '',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Category",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                state.item?.category ?? "",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                "Description",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                state.item?.description ?? "",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.item?.sellerName ?? "",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                state.item?.sellerAddress ?? "",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      context
                                          .read<DetailItemBloc>()
                                          .add(AddItemToCart(item: state.item!));
                                    });
                                  },
                                  icon: const Icon(Icons.trolley),
                                  label: const Text("Add to cart"),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: FilledButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return CheckoutPage(
                                              item: state.item ?? ItemModel.empty);
                                        }));
                                  },
                                  child: const Text("Buy Now"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
