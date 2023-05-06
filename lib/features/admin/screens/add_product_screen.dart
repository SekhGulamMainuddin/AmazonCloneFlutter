import 'dart:io';

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/services/product_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  static const String routeName = "/add-product";

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final ProductService addProductService = ProductService();
  final _formKey = GlobalKey<FormState>();

  void sellProduct() {
    if (_formKey.currentState!.validate() && selectedProductImages.isNotEmpty) {
      addProductService.uploadProduct(
        context: context,
        images: selectedProductImages,
        name: productNameController.text,
        description: descriptionController.text,
        category: category,
        price: double.parse(priceController.text),
        quantity: double.parse(quantityController.text),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  final productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion'
  ];

  String category = "Mobiles";
  List<File> selectedProductImages = [];
  var currentIndex= 0;

  void selectImages() async {
    final files = await pickImages();
    setState(() {
      selectedProductImages.clear();
      selectedProductImages.addAll(files);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            "Add Product",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                selectedProductImages.isNotEmpty
                ? Stack(
                  children: [
                    CarouselSlider(
                      items: selectedProductImages
                          .map(
                            (image) => Image.file(
                          image,
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                      )
                          .toList(),
                      options: CarouselOptions(
                        viewportFraction: 1,
                        height: 200,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 180,
                      alignment: Alignment.bottomCenter,
                      child: DotsIndicator(
                        dotsCount: selectedProductImages.length,
                        position: currentIndex.toDouble(),
                        decorator: DotsDecorator(
                          activeColor: GlobalVariables.selectedNavBarColor,
                        ),
                      ),
                    ),
                  ],
                ):GestureDetector(
                  onTap: () {
                    selectImages();
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    dashPattern: const [10, 4],
                    strokeCap: StrokeCap.round,
                    radius: const Radius.circular(10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.folder_open,
                            size: 40,
                          ),
                          Text(
                            "Select Product Images",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  controller: productNameController,
                  hint: "Product",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: descriptionController,
                  hint: "Description",
                  maxLines: 7,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: priceController,
                  hint: "Price",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: quantityController,
                  hint: "Quantity",
                ),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    items: productCategories
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onChanged: (val) {
                      setState(() {
                        category = val!;
                      });
                    },
                  ),
                ),
                CustomButton(onTap: sellProduct, text: "Sell"),
                const SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
