// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String quantity;
  final String productName;
   String  imageurl;
  VoidCallback onPressed;
  ProductCard({
    super.key,
    required this.productName,
    required this.quantity,
    required this.imageurl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                imageurl,
                fit: BoxFit.cover,
                height: 150,
              )),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    productName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                ),
                Flexible(child: Text(quantity))
              ],
            ),
          )
        ],
      ),
    );
  }
}
