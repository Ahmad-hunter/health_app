import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/pages/type_page.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/provider/provider.dart';
import 'detailspage.dart';
import '../models/reminder.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: Provider.of<ReminderProvider>(context, listen: false)
            .loadReminders(),
        builder: (context, snapshot) {
          return Consumer<ReminderProvider>(
              builder: ((context, provider, child) {
            List<Reminder> reminders = [];
            List<Reminder> completed = [];
            for (var i in provider.reminders) {
              if (widget.title == "Today") {
                print("today tasks");
                if (i.reminderDate ==
                    DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                  if (i.reminderCompleted == false) {
                    reminders.add(i);
                  } else {
                    completed.add(i);
                  }
                }
              } else if (widget.title != "Today") {
                if (i.reminderCompleted == false) {
                  reminders.add(i);
                } else {
                  completed.add(i);
                }
              }
            }

            return Scaffold(
              backgroundColor: Color.fromARGB(255, 52, 101, 129),
              drawer: Drawer(
                backgroundColor: Color.fromARGB(255, 49, 46, 46),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: width,
                        height: 80,
                        child: DrawerHeader(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 18, 82, 156),
                          ),
                          child: const Text(
                            'Welcome Patiant',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        height: height - 100,
                        child: Column(children: [
                          ListTile(
                            minVerticalPadding: 0,
                            title: Text(
                              "Today",
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: Icon(Icons.today),
                            iconColor: Colors.white,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyHomePage(title: "Today"),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: Text(
                              "All Reminders",
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: Icon(Icons.today),
                            iconColor: Colors.white,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyHomePage(title: "All Reminders"),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            flex: 1,
                            child: ListView.builder(
                                itemCount: provider.types.length,
                                itemBuilder: ((context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: ListTile(
                                      title: Text(
                                        provider.types[index].typeName!,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading:
                                          Icon(provider.types[index].typeIcon),
                                      iconColor: Colors.white,
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TypePage(typeId: index),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                })),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 18, 82, 156),
                title: Text(widget.title),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Color.fromARGB(255, 79, 83, 85),
                      height: 100 +
                          (60 * reminders.length.toDouble() +
                              60 * completed.length.toDouble()),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Text(
                                  "${reminders.length.toString()} reminders",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: width,
                              height: 55 * reminders.length.toDouble(),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: reminders.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Dismissible(
                                            key: Key(
                                                reminders[index].id.toString()),
                                            onDismissed: (direction) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${reminders[index].reminderName} reminder deleted')));
                                              provider.deleteReminder(
                                                  reminders[index].id!);
                                              setState(() {});
                                            },
                                            background: Container(
                                              color: Colors.red,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Icon(Icons.delete_outline),
                                                  Icon(Icons.delete_outline),
                                                ],
                                              ),
                                            ),
                                            child: ListTile(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailsScreen(
                                                        reminderId:
                                                            reminders[index].id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                trailing: IconButton(
                                                  icon: const Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    provider.changereminderState(
                                                        reminders[index].id!,
                                                        reminders[index]
                                                            .reminderCompleted!);

                                                    setState(() {});
                                                  },
                                                ),
                                                title: Container(
                                                  height: 40,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          reminders[index]
                                                              .reminderName!,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15)),
                                                      Text(
                                                        reminders[index]
                                                            .reminderDate!,
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    5,
                                                                    148,
                                                                    214),
                                                            fontSize: 15),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Text(
                                  "Completed : ${completed.length.toString()} reminders ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: width,
                              height: 55 * completed.length.toDouble(),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: completed.length,
                                        itemBuilder: (BuildContext context,
                                                int index) =>
                                            Container(
                                              child: Dismissible(
                                                key: Key(completed[index]
                                                    .id
                                                    .toString()),
                                                onDismissed: (direction) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              '${completed[index].reminderName} reminder deleted')));
                                                  provider.deleteReminder(
                                                      completed[index].id!);
                                                  setState(() {});
                                                },
                                                background: Container(
                                                  color: Colors.red,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: const [
                                                      Icon(
                                                          Icons.delete_outline),
                                                      Icon(
                                                          Icons.delete_outline),
                                                    ],
                                                  ),
                                                ),
                                                child: ListTile(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailsScreen(
                                                            reminderId:
                                                                completed[index]
                                                                    .id,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    trailing: IconButton(
                                                        icon: const Icon(
                                                            Icons.check_box),
                                                        onPressed: () {
                                                          provider.changereminderState(
                                                              completed[index]
                                                                  .id!,
                                                              completed[index]
                                                                  .reminderCompleted!);
                                                          setState(() {});
                                                        },
                                                        color: const Color
                                                                .fromARGB(255,
                                                            156, 168, 173)),
                                                    title: Container(
                                                      height: 40,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            completed[index]
                                                                .reminderName!,
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        156,
                                                                        168,
                                                                        173)),
                                                          ),
                                                          Text(
                                                            completed[index]
                                                                .reminderDate!,
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        156,
                                                                        168,
                                                                        173)),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 79, 83, 85),
                      height: 70,
                      width: width,
                      child: IconButton(
                          onPressed: () {
                            addReminder();
                          },
                          icon: const Icon(
                            Icons.add_box,
                            color: Color.fromARGB(255, 5, 148, 214),
                            size: 60,
                          )),
                    )
                  ],
                ),
              ),
              resizeToAvoidBottomInset: false,
            );
          }));
        });
  }

  Future addReminder() => showDialog(
      context: context,
      builder: (context) {
        String? reminderName = "";
        String? reminderType = "Medicine Reminders";
        String? reminderDate;
        return Consumer<ReminderProvider>(builder: ((context, provider, child) {
          return StatefulBuilder(builder: (context, setState) {
            reminderDate ??= DateFormat('yyyy-MM-dd').format(DateTime.now());
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 39, 39, 39),
              title: const Text(
                "Add new reminder",
                style: TextStyle(color: Colors.white),
              ),
              content: SizedBox(
                width: 250,
                height: 240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 250,
                        child: TextField(
                          style: TextStyle(
                              color: Color.fromARGB(255, 18, 82, 156)),
                          autofocus: true,
                          onChanged: (value) {
                            reminderName = value;
                          },
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: "reminder name",
                              fillColor: Colors.white,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 18, 82, 156))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 18, 82, 156))),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 18, 82, 156)))),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "reminder date",
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              reminderDate!,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 18, 82, 156)),
                            ),
                            IconButton(
                              onPressed: (() async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2100),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        dialogBackgroundColor: Colors.black,
                                        colorScheme: const ColorScheme.light(
                                          primary:
                                              Color.fromARGB(255, 18, 82, 156),
                                          onPrimary: Colors.white,
                                          onSurface: Colors.white,
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Color.fromARGB(
                                                255, 18, 82, 156),
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                setState(() {
                                  reminderDate = DateFormat('yyyy-MM-dd')
                                      .format(pickedDate!);
                                });
                              }),
                              icon: const Icon(
                                Icons.date_range,
                                color: Color.fromARGB(255, 18, 82, 156),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Icon(Icons.flag_outlined, color: Colors.white),
                        Icon(Icons.location_on, color: Colors.white),
                        Icon(Icons.inbox, color: Colors.white),
                      ],
                    ),
                    Container(
                      width: 250,
                      height: 100,
                      child: ListView.builder(
                        itemCount: provider.types.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              reminderType = provider.types[index].typeName;
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Text(
                                  provider.types[index].typeName!,
                                  style: TextStyle(
                                      color: provider.types[index].typeName ==
                                              reminderType
                                          ? Color.fromARGB(255, 18, 82, 156)
                                          : Colors.white),
                                ),
                                Icon(
                                  provider.types[index].typeIcon,
                                  color: provider.types[index].typeName ==
                                          reminderType
                                      ? Color.fromARGB(255, 18, 82, 156)
                                      : Colors.white,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: (() {
                      List<SimiReminder> simireminders = [];
                      Reminder reminder = Reminder(
                          reminderName: reminderName == ""
                              ? "unnamed reminder"
                              : reminderName,
                          reminderDate: reminderDate,
                          reminderCompleted: false,
                          remindertype: reminderType,
                          simiReminders: jsonEncode(simireminders));
                      provider.addreminder(reminder);

                      Navigator.of(context).pop();
                    }),
                    child: const Text(
                      "Add",
                      style: TextStyle(
                          color: Color.fromARGB(255, 18, 82, 156),
                          fontSize: 25),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "cancel",
                      style: TextStyle(color: Colors.red, fontSize: 25),
                    )),
              ],
            );
          });
        }));
      });
}
