import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  const ContactPage({Key? key, required this.contact}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final ImagePicker _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  late bool _userEdicted = false;

  late Contact _editedContact;

  // get _willPopCallback => null;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact(0, "", "", "", "");
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;

      // final _nameFocus = FocusNode();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    var _nameFocus;
    return WillPopScope(
      onWillPop: () async {
        return _requestPop();
      },
      // onWillPop: _requestPop(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name.isNotEmpty) {
              ContactHelper helper = ContactHelper();
              helper.saveContact(_editedContact);
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: const Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image:
                        DecorationImage(image: AssetImage("images/person.png")),
                  ),
                ),
                onTap: () {
                  _picker.pickImage(source: ImageSource.camera).then((file) {
                    if (file == null) return;
                    setState(() {
                      _editedContact.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: const InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdicted = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  _userEdicted = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                onChanged: (text) {
                  _userEdicted = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _requestPop() {
    if (_userEdicted) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: const Text("Descartar Alteracoes?"),
                content: const Text("Se sair as Alteracoes serao Perdidas!"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancelar!")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text("Sim!"))
                ]);
          });
      return false;
    } else {
      return true;
    }
  }
}
