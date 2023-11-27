import 'package:flutter/material.dart';
import 'package:userinfo/Database/models/sqlite.dart';


class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key,required this.userId}) : super(key: key);
  final int userId;

  @override
  State<UpdateUser> createState() => _UpdateUserState();

}

class _UpdateUserState extends State<UpdateUser> {
  final  TextEditingController _nameController = TextEditingController();
  final  TextEditingController _addressController = TextEditingController();
  final  TextEditingController _phoneController = TextEditingController();
  final  TextEditingController _emailController = TextEditingController();

void fetchData() async {
  Map<String, dynamic>? data = await Sqlite.getSingleData(widget.userId);
  if(data != null) {
    _nameController.text = data['name'];
    _addressController.text = data['address'];
    _phoneController.text = data['phone_no'].toString();
    _emailController.text = data['email_id'];
  }
}


  @override
  void initState(){
   fetchData();
   super.initState();
  }

  void _updateData(BuildContext context) async {
   Map<String, dynamic> data = {
     'name': _nameController.text,
     'address': _addressController.text,
     'phone_no': _phoneController.text,
     'email_id': _emailController.text
   };
   int id = await Sqlite.updateData(widget.userId, data);

   Navigator.pop(context,true);
  }

  @override
  void dispose(){
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update User'),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: "Enter Name"),
            ),
            //Container(height: 11),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(hintText: "Enter Address"),
            ),
            //Container(height: 11),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone,color: Colors.blue),
              ),
            ),
            //Container(height: 11),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email,color: Colors.blue,),
              ),
            ),
            ElevatedButton(onPressed: (){
              _updateData(context);
            },
                child: const Text(
                  'Update info',
                  style: TextStyle(color:Colors.black,
                      fontWeight: FontWeight.bold),))
          ],
        ),
      ),
    );
  }

}