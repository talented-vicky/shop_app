import 'package:flutter/material.dart';

import '../providers/product.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProduct({super.key});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocus = FocusNode();
  final _descFocus = FocusNode();
  final _imgUrlCtrl = TextEditingController();
  final _imgFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  // gives me access to the state of the form in this widget

  var _editProd = Product(
    id: null.toString(),
    title: "",
    imageUrl: "",
    description: "",
    price: 0,
  );

  @override
  void initState() {
    _imgFocus.addListener(_updateImgFocus);
    super.initState();
  }

  void _updateImgFocus() {
    if (!_imgFocus.hasFocus) {
      setState(() {
        // I'm not doing anything, but calling set state
        // lowkey updates the UI or invokes setstate
      });
    }
  }

  @override
  void dispose() {
    _priceFocus.dispose();
    _descFocus.dispose();
    _imgUrlCtrl.dispose();
    _imgFocus.removeListener(_updateImgFocus);
    // remove listener before disposing imagefocus
    _imgFocus.dispose();
    super.dispose();
  }

  void _submitForm() {
    _formKey.currentState!.save();
    // this ensures I have all my input saved securely
    print(_editProd.description);
    print(_editProd.title);
    print(_editProd.imageUrl);
    print(_editProd.price);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("Edit prod", style: TextStyle(color: Colors.black)),
        forceMaterialTransparency: true,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () => _submitForm(), icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: [
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_priceFocus),
                  onSaved: (input) => _editProd = Product(
                      id: null.toString(),
                      title: input!,
                      // I now store what was entered in this
                      // particular text_form_field
                      imageUrl: _editProd.imageUrl,
                      // I'm just keeping the existing edited
                      // product and storing it in this obj
                      description: _editProd.description,
                      price: _editProd.price)),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  focusNode: _priceFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_descFocus),
                  onSaved: (input) => _editProd = Product(
                      id: null.toString(),
                      title: _editProd.title,
                      imageUrl: _editProd.imageUrl,
                      description: _editProd.description,
                      price: double.parse(input!))),
              TextFormField(
                  decoration: const InputDecoration(labelText: "Description"),
                  focusNode: _descFocus,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  onSaved: (input) => _editProd = Product(
                      id: null.toString(),
                      title: _editProd.title,
                      imageUrl: _editProd.imageUrl,
                      description: input!,
                      price: _editProd.price)),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  padding: const EdgeInsets.only(top: 5, right: 5),
                  height: 70,
                  width: 90,
                  child: _imgUrlCtrl.text.isEmpty
                      ? Text('No image',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error))
                      : Image.network(_imgUrlCtrl.text, fit: BoxFit.cover),
                ),
                Expanded(
                    child: TextFormField(
                        decoration:
                            const InputDecoration(label: Text("Image Url")),
                        keyboardType: TextInputType.url,
                        controller: _imgUrlCtrl,
                        focusNode: _imgFocus,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submitForm(),
                        // calling the submitForm func fetches the obj
                        // in the onsaved callback
                        onSaved: (input) => _editProd = Product(
                            id: null.toString(),
                            title: _editProd.title,
                            imageUrl: input!,
                            description: _editProd.description,
                            price: _editProd.price))),
              ])
            ]))),
      ));
}
