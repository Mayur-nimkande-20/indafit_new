import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:project/dataModel.dart';
import 'package:indafit/model/model.dart';

//part 'model.g.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory = await getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter<ExerciseCategories>(ExerciseCategoriesAdapter());
  Hive.registerAdapter<MovementModel>(MovementModelAdapter());
  Hive.registerAdapter<ExerciseModel>(ExerciseModelAdapter());
  Hive.registerAdapter<UserModel>(UserModelAdapter());
  //Hive.deleteBoxFromDisk('exercise_box');
  await Hive.openBox<ExerciseCategories>('exercise_box');

  runApp(MyApp());

}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHiveDB(), // BluetoothApp() would be defined later
    );
  }
}
class MyHiveDB extends StatefulWidget {
  const MyHiveDB({super.key});

  @override
  MyHiveDBState createState() => MyHiveDBState();
}

class MyHiveDBState extends State<MyHiveDB> {
  late final Box<ExerciseCategories> dataBox;
  @override
  void initState() {
    super.initState();
    //Hive.deleteFromDisk();
    //Hive.deleteBoxFromDisk('exercise_box'); //To delete database but pre requsite is database must be closed
    //Hive.deleteBoxFromDisk('userInfo_box'); //To delete database but pre requsite is database must be closed

    dataBox = Hive.box<ExerciseCategories>('exercise_box');
    addData();
  }

  @override
  void dispose() async{
    print("object");
    await dataBox.close();
    //Hive.deleteBoxFromDisk('data_box');
    //Hive.deleteFromDisk();
    super.dispose();
  }
  addData() {
    /*Data newData = Data(
      title: "ABC",
      description: "SJT",
    );*/
  print("Adding Data");
    List<ExerciseModel> x=[];
    ExerciseModel tempExercise=ExerciseModel(set: "1", reps: "10", weight: "100 KGS", weightMode: "Standard", assistMode: "NIL");
    x.add(tempExercise);
    //tempMovement.sets.add(tempExercise);
  //print("Adding Data");
    tempExercise=ExerciseModel(set: "2", reps: "20", weight: "200 KGS", weightMode: "Stand", assistMode: "NONE");
    x.add(tempExercise);
    //tempMovement.sets.add(tempExercise);
  //print("Adding Data");
    MovementModel tempMovement=MovementModel(name: "Standing Chest Press",sets: x);
    List<MovementModel> y=[];
    y.add(tempMovement);
    tempMovement=MovementModel(name: "Cable Chest Fly",sets: x);
    y.add(tempMovement);
    tempMovement=MovementModel(name: "Chest Press",sets: x);
    y.add(tempMovement);
    tempMovement=MovementModel(name: "Bench Press",sets: x);
    y.add(tempMovement);
    ExerciseCategories tempCategories=ExerciseCategories(name: "Chest",shortName: 'CH',movements: y);
    tempCategories.movements.add(tempMovement);
    dataBox.add(tempCategories);

    y=[];
    tempMovement=MovementModel(name: "Dual Handle Row",sets: x);
    y.add(tempMovement);
    tempMovement=MovementModel(name: "Arm Pull Down",sets: x);
    y.add(tempMovement);
    tempMovement=MovementModel(name: "Lat Pull Down",sets: x);
    y.add(tempMovement);
    tempCategories=ExerciseCategories(name: "Back",shortName: 'Bk',movements: y);
    //dataBox.add(newData);
    dataBox.add(tempCategories);
    y=[];
    tempMovement=MovementModel(name: "Front Raise",sets: x);
    y.add(tempMovement);
    tempMovement=MovementModel(name: "Reverse Cable Fly",sets: x);
    y.add(tempMovement);
    tempMovement=MovementModel(name: "Shoulder Press",sets: x);
    y.add(tempMovement);
    tempCategories=ExerciseCategories(name: "Shoulders",shortName: 'SH',movements: y);
    //dataBox.add(newData);
    dataBox.add(tempCategories);

    print("Data Added");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HIVE Sample'),
        centerTitle: true,
        /*actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateScreen(),
              ),
            ),
            icon: const Icon(Icons.add),
          ),
        ],*/
      ),
      body: ValueListenableBuilder(
        valueListenable: dataBox.listenable(),
        builder: (context, value, child) {
          if (value.isEmpty) {
            return const Center(
              child: Text('Information Not Available'),
            );
          } else {
            return ListView.builder(
              itemCount: dataBox.length,
              itemBuilder: (context, index) {
                var box = value;
                var getData = box.getAt(index);
                return Column(children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: getData!.movements.length,
                    itemBuilder: (context, mIndex) {
                      //var box = value;
                      //var getData = box.getAt(index);

                      return ListTile(
                        leading: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                        title: Text(getData!.name),
                        subtitle: Text(getData!.movements[mIndex].name),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    },
                  )
                ],);
              },
            );
            /*return ListView.builder(
              itemCount: dataBox.length,
              itemBuilder: (context, index) {
                var box = value;
                var getData = box.getAt(index);

                return ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),
                  title: Text(getData!.name),
                  subtitle: Text(getData!.movements[0].name),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            );*/
          }
        },
      ),
    );
  }
}

