import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

//  CHANGED: importing dummy data from separate data file
import '../data/contact_data.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> _contacts = [];
  bool _loading = true;

  //  CHANGED: removed local dummy list
  // final List<String> _dummyContacts = ["AAA", "BBB", "CCC", "DDD", "EEE"];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    if (!await FlutterContacts.requestPermission()) {
      setState(() => _loading = false);
      return;
    }

    final contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
    );

    setState(() {
      _contacts = contacts;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final bool showDummy = _contacts.isEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: showDummy
        //  CHANGED: using dummy data from ContactData file
            ? ContactData.dummyNames
            .map(
              (name) => _contactCard(
            name: name,
            phone: "+91 9XXXXXXXXX",
            tag: "Dummy",
          ),
        )
            .toList()
            : _contacts.map((contact) {
          final phone = contact.phones.isNotEmpty
              ? contact.phones.first.number
              : "No number";

          return _contactCard(
            name: contact.displayName,
            phone: phone,
            tag: "Emergency",
          );
        }).toList(),
      ),
    );
  }

  // ================= CARD DESIGN =================

  Widget _contactCard({
    required String name,
    required String phone,
    required String tag,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.pink, Colors.red],
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            "$phone\nTag: $tag",
            style: const TextStyle(color: Colors.white70),
          ),
          isThreeLine: true,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.call, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.message, color: Colors.white),
                onPressed: () {},
              ),

              //  CHANGED: removed popup menu
              /*
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {},
                itemBuilder: (context) => const [
                  PopupMenuItem(value: "edit", child: Text("Edit")),
                  PopupMenuItem(value: "pin", child: Text("Pin to top")),
                ],
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
