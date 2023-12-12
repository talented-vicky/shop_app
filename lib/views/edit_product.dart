import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  // each focusNode objec helps user get to next formfield
  // upon 'enter' or clicking the 'next' icon
  final _formKey = GlobalKey<FormState>();
  // gives me access to the state of the form in this widget

  // creating an empty product to be populated upon form edit
  var _editProd = Product(
    id: null,
    title: '',
    imageUrl: '',
    description: '',
    price: 0,
  );

  var _initState = true;
  var _isLoading = false;

  // setting initial empty strings for the form field
  var _initObj = {
    'id': null,
    'title': '',
    'imageUrl': '',
    'description': '',
    'price': '',
  };

  @override
  void initState() {
    _imgFocus.addListener(_updateImgFocus);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // I wanna do all the actions in the if statement because
    // I am loading it for the first time
    if (_initState) {
      final prodId = ModalRoute.of(context)!.settings.arguments;
      // final prodId = ModalRoute.of(context)!.settings.arguments as dynamic;

      // since I'm on the editScreen, although I pass
      // argument into the user_prod_item view widget,
      // I don't do so in the
      if (prodId != null) {
        // Fetching a prodId may yield null if the product
        // doesn't exist, hence checking
        // Now, I'm initializing the values differently cause
        // I did find a loaded product
        _editProd = Provider.of<Products>(context, listen: false)
            .findbyId(prodId.toString());

        // now overiting the empty strings initialized above
        // with input from previously stored formfield
        _initObj = {
          'id': _editProd.id,
          'title': _editProd.title,
          // 'imageUrl': _editProd.imageUrl,
          'description': _editProd.description,
          'price': _editProd.price.toString(),
          'imageUrl': '',
        };
        _imgUrlCtrl.text = _editProd.imageUrl;
      }
    }
    _initState = false;
    // by setting initstate to false I ensure didchangedep never
    // runs again

    super.didChangeDependencies();
  }

  void _updateImgFocus() {
    if (!_imgFocus.hasFocus) {
      setState(() {
        // I'm not doing anything, but calling set state
        // lowkey updates the UI or invokes state check
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

  Future<void> _submitForm() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return; // false means there are errors
    }
    _formKey.currentState!.save();
    // this ensures I have all my input saved

    setState(() => _isLoading = true);
    // I show a loading inidiator imediately I click save
    // wrapped in a setstate thou to reflect in the UI

    if (_editProd.id != null) {
      // product exists before
      await Provider.of<Products>(context, listen: false)
          .updateOne(_editProd.id, _editProd);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProd);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctxt) => AlertDialog(
                    title: const Text('Error Occured'),
                    content: const Text(
                        'Check your internet connection, or your proxy server'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(ctxt).pop(),
                          child: const Text('Okay'))
                    ]));
      }
      // finally {
      //   // runs irrespective of the try and/or catch running
      //   setState(() => _isLoading = false);
      //   Navigator.of(context).pop();
      // }
    }
    // the code below will now run if any of the if/else
    // stuff runs
    setState(() => _isLoading = false);
    Navigator.of(context).pop();
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
          ]),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      child: Column(children: [
                    TextFormField(
                        // displaying the empty or previously entered
                        // value for this formfield
                        initialValue: _initObj['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        // User will be taken to the next formfield (price in
                        // this case) when enter is hit on this current formfield
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_priceFocus),
                        validator: (input) {
                          if (input!.isEmpty) {
                            return 'Title cannot be blank';
                          }
                          return null;
                        },
                        onSaved: (input) => _editProd = Product(
                            id: _editProd.id,
                            title: input!,
                            // I now store what was entered in this
                            // particular text formfield
                            imageUrl: _editProd.imageUrl,
                            // I'm just keeping the existing edited
                            // product value that belongs to this prod
                            description: _editProd.description,
                            price: _editProd.price,
                            isFav: _editProd.isFav)),
                    TextFormField(
                        initialValue: _initObj['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        focusNode: _priceFocus,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_descFocus),
                        validator: (input) {
                          if (input!.isEmpty) {
                            return 'Must enter price';
                          }
                          if (double.tryParse(input) == null) {
                            // normally returns null if input is
                            // invalid (i.e a non number type)
                            return 'Invalid amount';
                          }
                          if (double.parse(input) <= 0) {
                            // here, we're certain input is an actual
                            // number type
                            return 'Price must be greater than 0';
                          }
                          return null;
                          // returning null at this point means all checks
                          // have been passed hence submission occurs
                        },
                        onSaved: (input) => _editProd = Product(
                            id: _editProd.id,
                            title: _editProd.title,
                            imageUrl: _editProd.imageUrl,
                            description: _editProd.description,
                            price: double.parse(input!),
                            isFav: _editProd.isFav)),
                    TextFormField(
                        initialValue: _initObj['description'],
                        decoration:
                            const InputDecoration(labelText: "Description"),
                        focusNode: _descFocus,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (input) {
                          if (input!.isEmpty) {
                            return 'Description cannot be blank';
                          }
                          if (input.length < 12) {
                            return 'Min of 18 chars required';
                          }
                          return null;
                        },
                        onSaved: (input) => _editProd = Product(
                            id: _editProd.id,
                            title: _editProd.title,
                            imageUrl: _editProd.imageUrl,
                            description: input!,
                            price: _editProd.price,
                            isFav: _editProd.isFav)),
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Container(
                        padding: const EdgeInsets.only(top: 5, right: 5),
                        height: 70,
                        width: 90,
                        child: _imgUrlCtrl.text.isEmpty
                            ? Text('No image',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error))
                            : Image.network(_imgUrlCtrl.text,
                                fit: BoxFit.cover),
                      ),
                      Expanded(
                        child: TextFormField(
                          // initialValue: null,
                          // I can't use an initvalue cause I already
                          // used a controller
                          decoration:
                              const InputDecoration(label: Text("Image Url")),
                          keyboardType: TextInputType.url,
                          controller: _imgUrlCtrl,
                          focusNode: _imgFocus,
                          textInputAction: TextInputAction.done,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Image Cannot Be Blank';
                            }
                            return null;
                          },
                          onSaved: (input) => _editProd = Product(
                              id: _editProd.id,
                              title: _editProd.title,
                              imageUrl: input!,
                              description: _editProd.description,
                              price: _editProd.price,
                              isFav: _editProd.isFav),
                          onFieldSubmitted: (_) => _submitForm(),
                        ),
                        // calling the submitForm func fetches the obj
                        // in the onsaved callback
                      )
                    ])
                  ]))),
            ));
}
