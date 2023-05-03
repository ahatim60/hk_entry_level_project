import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hk_entry_level_task/pages/add_product_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  List products;
  HomePage({super.key, required this.products});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getStringList('products');
    if (data != null) {
      setState(() {
        widget.products = data.map((item) => json.decode(item)).toList();
      });
    }
    setState(() {});
  }

  Future<void> _deleteProduct(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var existingProducts = prefs.getStringList('products');
    existingProducts!.removeAt(index);
    await prefs.setStringList('products', existingProducts);
    setState(() {
      widget.products.removeAt(index);
    });
  }

  void _searchProducts(String query) {
    if (query.isNotEmpty) {
      List filteredProducts = widget.products
          .where((product) =>
              product['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        widget.products = filteredProducts;
      });
    } else {
      _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Hi-Fi Shop & Service",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          TextField(
            onChanged: _searchProducts,
            decoration: const InputDecoration(
              labelText: 'Search Products',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.products.length,
              itemBuilder: (BuildContext context, int index) {
                var product = widget.products[index];
                return Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 4,
                            color: Color(0x320E151B),
                            offset: Offset(0, 1))
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Hero(
                            tag: "tag",
                            transitionOnUserGestures: true,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: product['image'] != ''
                                  ? Image.memory(
                                      base64Decode(product['image']),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.fitWidth,
                                    )
                                  : const Icon(Icons.image),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 8),
                                  child: Text(widget.products[index]['name']),
                                ),
                                Text('\$${widget.products[index]['price']}'),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _deleteProduct(index),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFE86969),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddProductPage(),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
