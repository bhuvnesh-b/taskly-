//creating a homepage class which will be used by the main file
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'package:taskly/models/task.dart';



//for stateful widget we create a private class and use that in this stateful widget

class HomePage extends StatefulWidget {
  HomePage();
  //we create a create state function in statefulwidget

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

//private class starts with _ and it cannot be imported to other files
class _HomePageState extends State<HomePage> {

  late double _deviceheight,_devicewidth;

  String? _newTaskContent;
  Box? _box;

  _HomePageState();
  
  // in private classes we use build function to define what our program will do
  @override
  Widget build(BuildContext context) {
    _deviceheight = MediaQuery.of(context).size.height;
    _devicewidth = MediaQuery.of(context).size.width;
    print("Input Value: $_newTaskContent");
    return Scaffold(
      //for making top bar of an app
      appBar: AppBar(
        toolbarHeight: _deviceheight*.15,
        // for writing a text on the upper bar of the app
        title: const Text("Taskly!", style:
        TextStyle(
          fontSize: 24
        )),
      ),
      body: _tasksView(),
      floatingActionButton: _addTaskButton(),
    );
  }


Widget _tasksView() {
  Hive.openBox('tasks');
  //as it will take time for hive box to open and give the data hence making a funtion so that
  //the next statement doesnt get executed before rendering hive box
  //we will use a futre builder widget in which we can specify what to do when the above is executed and when it is not 
  return FutureBuilder(
    //delaying until the data is fetched form hive
    future: Hive.openBox('tasks'),
    builder: (BuildContext _context,AsyncSnapshot _snapshot) {
        if(_snapshot.hasData){
            _box = _snapshot.data;
            return _taskList();

        }
        else {
          return const Center(child: CircularProgressIndicator());
        }
    },
    );
}
//making the list view in our app
  Widget _taskList() {
    // Task _newTask = Task(content: "eat lunch", timestamp: DateTime.now(), done: false);
    // //putting question mark means if the box has some value then put it otherwise no 
    // _box?.add(_newTask.toMap());

//!mark means that there will be some values int tasks for sure
    List tasks = _box!.values.toList();
    return 
    ListView.builder(itemCount: tasks.length , 
    itemBuilder: (BuildContext _context,int _index) {
      var task = Task.fromMap(tasks [_index]);
      return ListTile(
            title: Text(task.content , style:  TextStyle(
              decoration:(
                task.done ? TextDecoration.lineThrough:null
              ),
            )),
            subtitle: Text(task.timestamp.toString()),

            //we can add things like ckeckboxes using trailing
            //and writing the logic for check boxes
            trailing:  Icon(
              task.done ? Icons.check_box_outlined
                        :Icons.check_box_outline_blank_outlined,
              color: Colors.red,
            ),

            //specifying what will be changed when cliking any content of the list
            onTap: () {
              task.done = !task.done;
              _box!.putAt(_index, task.toMap());
              setState((){});
            },
            onLongPress: (){
              _box!.deleteAt(_index);
              setState((){});
            },
        );
        //  ListTile(
        //     title: const Text("Do breakfast!" , style: TextStyle(
        //       decoration:(
        //         TextDecoration.lineThrough
        //       ),
        //     )),
        //     subtitle: Text(DateTime.now().toString()),

        //     //we can add things like ckeckboxes using trailing
        //     trailing: const Icon(
        //       Icons.check_box_outlined,
        //       color: Colors.red,
        //     ),
        // ),
    }

    );
    
    
    // // ListView(
    //   //we need to provide children in a listview 
    //   children: [
    //     //Things to be displayed in the list
        
    //   ],
    // );
  }

//implementing the buton 
  Widget _addTaskButton() {
    return FloatingActionButton(
      //is this write what message will be displayed in the console if the button is pressed
      onPressed: 
        _displayTaskPopup,
      //icon on the button + in this case
      child: const Icon(Icons.add),
    );
  }

  //making a function for displaying a pop if the button is clicked 
  void _displayTaskPopup(){
    showDialog(context: context, builder: (BuildContext _context) {
      return AlertDialog(
        title: const Text("Add New Task!"),
        //for a text field so that we can provide input
        content: TextField(

          //this field defines what will happen if we add a task by cliking the + button
          onSubmitted: (_) {
            if(_newTaskContent !=null) {
              var _task = Task(content: _newTaskContent!,
              timestamp: DateTime.now(),
              done: false,);
              _box!.add(_task.toMap());
              //for rerendering the list function 
              setState((){
                _newTaskContent = null;
                Navigator.pop(context);
              }
              );
            }
          },

          //if at any time the input value changes then save it 
          onChanged: (_value){
            setState(() {
              _newTaskContent = _value;
            });
          },
        ),
      );
    });
    
  }
}