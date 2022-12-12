import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/provider/provider.dart';
import 'models/reminder.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.typeId});

  int typeId;

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
              if (i.remindertype == provider.types[widget.typeId].typeName!) {
                if (i.reminderCompleted == false) {
                  reminders.add(i);
                } else {
                  completed.add(i);
                }
              }
            }
            return Scaffold(
              backgroundColor: Colors.black,
              drawer: Drawer(
                backgroundColor: Color.fromARGB(255, 49, 46, 46),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Welcome Patiant',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.settings_outlined,
                                  color: Colors.white,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 90,
                      child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
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
                                    builder: (context) => MyHomePage(typeId: 0),
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
                                    builder: (context) => MyHomePage(typeId: 0),
                                  ),
                                );
                              },
                            ),
                          ]),
                    ),
                    Container(
                      height: height - 100,
                      child: Expanded(
                        flex: 1,
                        child: ListView.builder(
                            itemCount: provider.types.length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: ListTile(
                                  tileColor: Colors.black,
                                  trailing: Text(provider
                                      .types[index].reminderCount
                                      .toString()),
                                  title: Text(
                                    provider.types[index].typeName!,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: Icon(provider.types[index].typeIcon),
                                  iconColor: Colors.white,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MyHomePage(typeId: index),
                                      ),
                                    );
                                  },
                                ),
                              );
                            })),
                      ),
                    ),
                  ],
                ),
              ),
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text("Medical Care"),
              ),
              body: SingleChildScrollView(
                child: Container(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Container(
                        color: Color.fromARGB(255, 39, 39, 39),
                        height: 100 +
                            (60 * reminders.length.toDouble() +
                                60 * completed.length.toDouble()),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Dismissible(
                                              key: Key(reminders[index]
                                                  .id
                                                  .toString()),
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
                                                  onTap: () =>
                                                      showSimiReminders(
                                                          reminders[index].id!),
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
                                                              color: Colors
                                                                  .orangeAccent,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                                    ScaffoldMessenger.of(
                                                            context)
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
                                                        Icon(Icons
                                                            .delete_outline),
                                                        Icon(Icons
                                                            .delete_outline),
                                                      ],
                                                    ),
                                                  ),
                                                  child: ListTile(
                                                      onTap: () =>
                                                          showSimiReminders(
                                                              completed[index]
                                                                  .id!),
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
                                                      /*  trailing: Text(
                                                        completed[index]
                                                            .reminderDate!,
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    156,
                                                                    168,
                                                                    173)),
                                                      ),*/
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
                        height: 70,
                        width: width,
                        color: Color.fromARGB(255, 39, 39, 39),
                        child: IconButton(
                            onPressed: () {
                              addReminder(
                                  provider.types[widget.typeId].typeName!);
                            },
                            icon: const Icon(
                              Icons.add_box,
                              color: Colors.orange,
                              size: 60,
                            )),
                      )
                    ],
                  ),
                ),
              ),
              resizeToAvoidBottomInset: false,
            );
          }));
        });
  }

  Future addReminder(String type) => showDialog(
      context: context,
      builder: (context) {
        String? reminderName = "";
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
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 250,
                        child: TextField(
                          style: TextStyle(color: Colors.orange),
                          autofocus: true,
                          onChanged: (value) {
                            reminderName = value;
                          },
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: "reminder name",
                              fillColor: Colors.white,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange)),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.orange))),
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
                              style: TextStyle(color: Colors.orange),
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
                                          primary: Colors.orange,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.white,
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.orange,
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
                                color: Colors.orange,
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
                          remindertype: type,
                          id: provider.reminders.length,
                          simiReminders: jsonEncode(simireminders));
                      provider.addreminder(reminder);

                      Navigator.of(context).pop();
                    }),
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Colors.orange, fontSize: 25),
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
  showSimiReminders(int id) {
    String? simiReminderName = "";
    String? simiReminderDate;
    final TextEditingController _controller = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: ((context) {
          simiReminderDate ??= DateFormat('yyyy-MM-dd').format(DateTime.now());

          return StatefulBuilder(builder: (context, setState) {
            return Consumer<ReminderProvider>(
                builder: ((context, provider, child) {
              Reminder reminder = provider.reminders.firstWhere(
                (element) => element.id == id,
              );

              return StatefulBuilder(builder: (context, setState) {
                List<SimiReminder> simireminders = [];
                simireminders = List<SimiReminder>.from(
                    jsonDecode(reminder.simiReminders!)
                        .map((i) => SimiReminder.fromJson(i)));

                return Container(
                  color: Colors.black,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 39, 39, 39),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    width: MediaQuery.of(context).size.width - 20,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "simireminders of ${reminder.reminderName}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    provider.changeRemindertype(reminder.id,
                                        provider.types[index].typeName!);
                                    super.setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        provider.types[index].typeIcon!,
                                        color: reminder.remindertype ==
                                                provider.types[index].typeName!
                                            ? Colors.orange
                                            : Colors.white,
                                      ),
                                      Text(
                                        provider.types[index].typeName!,
                                        style: TextStyle(
                                          color: reminder.remindertype ==
                                                  provider
                                                      .types[index].typeName!
                                              ? Colors.orange
                                              : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: provider.types.length,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: 150,
                                  child: TextField(
                                    style: TextStyle(color: Colors.orange),
                                    controller: _controller,
                                    onChanged: (value) {
                                      simiReminderName = value;
                                    },
                                    decoration: const InputDecoration(
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        hintText: "simi reminder name",
                                        fillColor: Colors.white,
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.orange)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.orange)),
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.orange))),
                                  )),
                              Row(
                                children: [
                                  Text(
                                    simiReminderDate!,
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                  IconButton(
                                    onPressed: (() async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2100),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              dialogBackgroundColor:
                                                  Colors.black,
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: Colors.orange,
                                                onPrimary: Colors.white,
                                                onSurface: Colors.white,
                                              ),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  foregroundColor:
                                                      Colors.orange,
                                                ),
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );

                                      setState(() {
                                        simiReminderDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate!);
                                      });
                                    }),
                                    icon: const Icon(
                                      Icons.date_range,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: (() {
                                    FocusScope.of(context).unfocus();
                                    _controller.clear();
                                    simireminders.add(SimiReminder(
                                        simiReminderName: simiReminderName == ""
                                            ? "UNAMED simireminder"
                                            : simiReminderName,
                                        simiReminderDate: simiReminderDate,
                                        simiReminderCompleted: false));

                                    provider.updatesimiReminder(
                                        reminder.id, jsonEncode(simireminders));
                                    setState(() {});
                                    super.setState(() {});
                                  }),
                                  icon: const Icon(
                                    Icons.add_box,
                                    color: Colors.orange,
                                  ))
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: ListView.builder(
                              itemCount: simireminders.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                    leading: IconButton(
                                        icon: Icon(
                                            simireminders[index]
                                                        .simiReminderCompleted ==
                                                    false
                                                ? Icons.check_box_outline_blank
                                                : Icons.check_box,
                                            color: simireminders[index]
                                                        .simiReminderCompleted ==
                                                    false
                                                ? Colors.orange
                                                : const Color.fromARGB(
                                                    255, 156, 168, 173)),
                                        onPressed: () {
                                          simireminders[index]
                                                  .simiReminderCompleted =
                                              !simireminders[index]
                                                  .simiReminderCompleted!;

                                          provider.updatesimiReminder(
                                              id, jsonEncode(simireminders));
                                          super.setState(() {});
                                          setState(() {});
                                        },
                                        color: simireminders[index]
                                                    .simiReminderCompleted ==
                                                false
                                            ? const Color.fromARGB(
                                                255, 0, 8, 12)
                                            : const Color.fromARGB(
                                                255, 156, 168, 173)),
                                    trailing: Text(
                                      simireminders[index].simiReminderDate!,
                                      style: TextStyle(
                                          color: simireminders[index]
                                                      .simiReminderCompleted ==
                                                  false
                                              ? Colors.orange
                                              : const Color.fromARGB(
                                                  255, 156, 168, 173)),
                                    ),
                                    title: Text(
                                      simireminders[index].simiReminderName!,
                                      style: TextStyle(
                                          color: simireminders[index]
                                                      .simiReminderCompleted ==
                                                  false
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                  255, 156, 168, 173)),
                                    ));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            }));
          });
        }));
  }
}
