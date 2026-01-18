import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> _contacts = [];
  bool _loading = true;

  final List<String> _dummyContacts = ["AAA", "BBB", "CCC", "DDD", "EEE"];

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
            ? _dummyContacts
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
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$phone\nTag: $tag"),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.message, color: Colors.blue),
              onPressed: () {},
            ),
            PopupMenuButton<String>(
              onSelected: (value) {},
              itemBuilder: (context) => const [
                PopupMenuItem(value: "edit", child: Text("Edit")),
                PopupMenuItem(value: "pin", child: Text("Pin to top")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
