import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/contactViewModel.dart';

class ContactUsPage extends StatelessWidget {
  static String routeName = "Contact";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactUsViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('Contact Us'),
              Spacer(),
              Image(image: AssetImage('assets/images/psychology.png'),height: 40,width: 40,)
            ],
          ),
          backgroundColor: Color.fromRGBO(72, 132, 151, 1),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<ContactUsViewModel>(
            builder: (context, viewModel, child) {
              return Form(
                key: viewModel.formKey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onSaved: (value) => viewModel.setName(value!),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!value.contains('@') || !value.contains('.')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (value) => viewModel.setEmail(value!),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Message'),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your message';
                          }
                          return null;
                        },
                        onSaved: (value) => viewModel.setMessage(value!),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(72, 132, 151, 1),
                          ),
                        ),
                        onPressed: viewModel.isSubmitting
                            ? null
                            : () => viewModel.submit(context),
                        child: viewModel.isSubmitting
                            ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                            : Text('Submit'),
                      ),
                      SizedBox(height: 50,),
                      Image(image: AssetImage("assets/images/Contact us.gif"))
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
