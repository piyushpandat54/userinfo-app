import 'package:flutter/material.dart';
import 'package:userinfo/Database/models/sqlite.dart';
import 'package:userinfo/update_user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  List<Map<String, dynamic>> dataList = [];

  void _saveData() async {
    final name = _nameController.text;
    final address = _addressController.text;
    final phone_no = int.tryParse(_phoneController.text) ?? 0;
    final email_id = _emailController.text;
    int insertId = await Sqlite.insertUser(name, address, phone_no, email_id);
    print(insertId);

    List<Map<String, dynamic>> updatedData =  await Sqlite.getData();
    setState(() {
      dataList = updatedData;
    });
    _nameController.text = '';
    _phoneController.text = '';

  }

  @override
  void initState(){
    _fetchUsers();
    super.initState();
  }

  void _fetchUsers() async {
    List<Map<String, dynamic>> userList =  await Sqlite.getData();
    setState(() {
      dataList = userList;
    });
  }

  void _delete(int docId) async{
    int id = await Sqlite.deleteData(docId);
    List<Map<String, dynamic>> updatedData = await Sqlite.getData();
    setState(() {
      dataList = updatedData;
    });
  }

  void fetchData() async {
    List<Map<String, dynamic>> fetchData = await Sqlite.getData();
    setState(() {
      dataList = fetchData;
    });
  }

  @override
  void dispose(){
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.cyan,

        title: Text('Employees Info'),
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Column(
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
                    //Container(height: 11),
                    ElevatedButton(onPressed: _saveData,
                        child: const Text(
                                'Submit',
                                 style: TextStyle(color:Colors.black,
                                 fontWeight: FontWeight.bold),))
                  ],
                ),
                SizedBox(height: 30,),
                Expanded(child: ListView.builder(itemCount: dataList.length,itemBuilder: (context, index){
                  return ListTile(
                    title: Text(dataList[index]['name']),
                    subtitle: Text('Phone no: ${dataList[index]['phone_no']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateUser(userId: dataList[index]['id']),
                              ),
                          ).then((result) {
                            if (result == true) {
                              fetchData();
                            }
                          });
                        }, icon: Icon(Icons.edit,color: Colors.green,)),
                        IconButton(
                          onPressed: (){
                            _delete(dataList[index]['id']);
                          },
                          icon: const Icon(Icons.delete,color: Colors.red,),),
                      ],
                    ),
                  );
                }
                )
                )
              ],
            ),
          ),
        ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
