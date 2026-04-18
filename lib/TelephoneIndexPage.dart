import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TelephoneIndexPage extends StatefulWidget {
  const TelephoneIndexPage({super.key});

  @override
  State<TelephoneIndexPage> createState() => _TelephoneIndexPageState();
}

class _TelephoneIndexPageState extends State<TelephoneIndexPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  // Categories for filtering
  final List<String> _categories = [
    'All',
    '🚨 Emergency',
    '🏢 District Police',
    '📡 Range Offices',
    '👮 Officers & Units',
  ];

  // All contact data organized
  final List<Map<String, String>> _allContacts = [];

  @override
  void initState() {
    super.initState();
    _buildAllContacts();
  }

  void _buildAllContacts() {
    // 1. Emergency Numbers
    _allContacts.addAll([
      {
        "name": "🚨 Police Emergency",
        "number": "119",
        "category": "🚨 Emergency",
        "district": "National",
      },
      {
        "name": "🚨 Emergency Information",
        "number": "118",
        "category": "🚨 Emergency",
        "district": "National",
      },
      {
        "name": "IG's Command Room",
        "number": "0112854931",
        "category": "🚨 Emergency",
        "district": "Colombo",
      },
      {
        "name": "Police Information - Room",
        "number": "0112854893",
        "category": "🚨 Emergency",
        "district": "Colombo",
      },
      {
        "name": "Police Information - Duty Officer",
        "number": "0112854880",
        "category": "🚨 Emergency",
        "district": "Colombo",
      },
      {
        "name": "Police Information - Command",
        "number": "0112823788",
        "category": "🚨 Emergency",
        "district": "Colombo",
      },
      {
        "name": "Police Information - Room 2",
        "number": "0112854885",
        "category": "🚨 Emergency",
        "district": "Colombo",
      },
    ]);

    // 2. Colombo District
    _allContacts.addAll([
      {
        "name": "🏢 Colombo Central Police",
        "number": "0112433333",
        "category": "🏢 District Police",
        "district": "Colombo",
      },
      {
        "name": "🏢 Maradana Police",
        "number": "0112691111",
        "category": "🏢 District Police",
        "district": "Colombo",
      },
      {
        "name": "🏢 Fort Police",
        "number": "0112321234",
        "category": "🏢 District Police",
        "district": "Colombo",
      },
      {
        "name": "Colombo Emergency 1",
        "number": "0112422521",
        "category": "🏢 District Police",
        "district": "Colombo",
      },
      {
        "name": "Colombo Emergency 2",
        "number": "0112446736",
        "category": "🏢 District Police",
        "district": "Colombo",
      },
    ]);

    // 3. Gampaha District
    _allContacts.addAll([
      {
        "name": "🏢 Gampaha Police",
        "number": "0332222228",
        "category": "🏢 District Police",
        "district": "Gampaha",
      },
      {
        "name": "🏢 Negombo Police",
        "number": "0312233333",
        "category": "🏢 District Police",
        "district": "Gampaha",
      },
      {
        "name": "🏢 Ja-Ela Police",
        "number": "0112233445",
        "category": "🏢 District Police",
        "district": "Gampaha",
      },
      {
        "name": "Gampaha Emergency",
        "number": "0332222222",
        "category": "🏢 District Police",
        "district": "Gampaha",
      },
      {
        "name": "Gampaha Ops Room",
        "number": "0332222223",
        "category": "🏢 District Police",
        "district": "Gampaha",
      },
    ]);

    // 4. Kalutara District
    _allContacts.addAll([
      {
        "name": "🏢 Kalutara Police",
        "number": "0342222227",
        "category": "🏢 District Police",
        "district": "Kalutara",
      },
      {
        "name": "🏢 Beruwala Police",
        "number": "0342279966",
        "category": "🏢 District Police",
        "district": "Kalutara",
      },
      {
        "name": "🏢 Panadura Police",
        "number": "0382233333",
        "category": "🏢 District Police",
        "district": "Kalutara",
      },
      {
        "name": "Kalutara Ops Room",
        "number": "0342236409",
        "category": "🏢 District Police",
        "district": "Kalutara",
      },
    ]);

    // 5. Kandy District
    _allContacts.addAll([
      {
        "name": "🏢 Kandy Police",
        "number": "0812233333",
        "category": "🏢 District Police",
        "district": "Kandy",
      },
      {
        "name": "🏢 Peradeniya Police",
        "number": "0812388888",
        "category": "🏢 District Police",
        "district": "Kandy",
      },
      {
        "name": "🏢 Gampola Police",
        "number": "0812352227",
        "category": "🏢 District Police",
        "district": "Kandy",
      },
      {
        "name": "Kandy Ops Room",
        "number": "0812234337",
        "category": "🏢 District Police",
        "district": "Kandy",
      },
      {
        "name": "Gampola Ops Room",
        "number": "0812352854",
        "category": "🏢 District Police",
        "district": "Kandy",
      },
    ]);

    // 6. Matale District
    _allContacts.addAll([
      {
        "name": "🏢 Matale Police",
        "number": "0662222222",
        "category": "🏢 District Police",
        "district": "Matale",
      },
      {
        "name": "🏢 Dambulla Police",
        "number": "0662288888",
        "category": "🏢 District Police",
        "district": "Matale",
      },
      {
        "name": "🏢 Sigiriya Police",
        "number": "0662255555",
        "category": "🏢 District Police",
        "district": "Matale",
      },
      {
        "name": "Matale Ops Room",
        "number": "0662224753",
        "category": "🏢 District Police",
        "district": "Matale",
      },
      {
        "name": "Matale Emergency",
        "number": "0662222221",
        "category": "🏢 District Police",
        "district": "Matale",
      },
    ]);

    // 7. Nuwara Eliya District
    _allContacts.addAll([
      {
        "name": "🏢 Nuwara Eliya Police",
        "number": "0522222222",
        "category": "🏢 District Police",
        "district": "Nuwara Eliya",
      },
      {
        "name": "🏢 Hatton Police",
        "number": "0512222227",
        "category": "🏢 District Police",
        "district": "Nuwara Eliya",
      },
      {
        "name": "🏢 Talawakele Police",
        "number": "0522233333",
        "category": "🏢 District Police",
        "district": "Nuwara Eliya",
      },
      {
        "name": "Nuwara Eliya Ops Room",
        "number": "0522222398",
        "category": "🏢 District Police",
        "district": "Nuwara Eliya",
      },
      {
        "name": "Hatton Ops Room",
        "number": "0512223882",
        "category": "🏢 District Police",
        "district": "Nuwara Eliya",
      },
    ]);

    // 8. Galle District
    _allContacts.addAll([
      {
        "name": "🏢 Galle Police",
        "number": "0912232061",
        "category": "🏢 District Police",
        "district": "Galle",
      },
      {
        "name": "🏢 Elpitiya Police",
        "number": "0912291032",
        "category": "🏢 District Police",
        "district": "Galle",
      },
      {
        "name": "🏢 Ambalangoda Police",
        "number": "0912255555",
        "category": "🏢 District Police",
        "district": "Galle",
      },
      {
        "name": "Galle Emergency",
        "number": "0912233333",
        "category": "🏢 District Police",
        "district": "Galle",
      },
      {
        "name": "Galle Ops Room",
        "number": "0912222222",
        "category": "🏢 District Police",
        "district": "Galle",
      },
      {
        "name": "Elpitiya Ops Room",
        "number": "0912291222",
        "category": "🏢 District Police",
        "district": "Galle",
      },
    ]);

    // 9. Matara District
    _allContacts.addAll([
      {
        "name": "🏢 Matara Police",
        "number": "0412222996",
        "category": "🏢 District Police",
        "district": "Matara",
      },
      {
        "name": "🏢 Akuressa Police",
        "number": "0412288888",
        "category": "🏢 District Police",
        "district": "Matara",
      },
      {
        "name": "🏢 Tangalle Police",
        "number": "0472244444",
        "category": "🏢 District Police",
        "district": "Matara",
      },
      {
        "name": "Matara Ops Room",
        "number": "0412222213",
        "category": "🏢 District Police",
        "district": "Matara",
      },
      {
        "name": "Tangalle Ops Room",
        "number": "0472241013",
        "category": "🏢 District Police",
        "district": "Matara",
      },
      {
        "name": "Tangalle Emergency",
        "number": "0472240229",
        "category": "🏢 District Police",
        "district": "Matara",
      },
    ]);

    // 10. Hambantota District
    _allContacts.addAll([
      {
        "name": "🏢 Hambantota Police",
        "number": "0472222222",
        "category": "🏢 District Police",
        "district": "Hambantota",
      },
      {
        "name": "🏢 Tissamaharama Police",
        "number": "0472233333",
        "category": "🏢 District Police",
        "district": "Hambantota",
      },
      {
        "name": "🏢 Ambalantota Police",
        "number": "0472255555",
        "category": "🏢 District Police",
        "district": "Hambantota",
      },
    ]);

    // 11. Jaffna District
    _allContacts.addAll([
      {
        "name": "🏢 Jaffna Police",
        "number": "0212222222",
        "category": "🏢 District Police",
        "district": "Jaffna",
      },
      {
        "name": "🏢 Point Pedro Police",
        "number": "0212288888",
        "category": "🏢 District Police",
        "district": "Jaffna",
      },
      {
        "name": "🏢 Chavakachcheri Police",
        "number": "0212255555",
        "category": "🏢 District Police",
        "district": "Jaffna",
      },
    ]);

    // 12. Kilinochchi District
    _allContacts.addAll([
      {
        "name": "🏢 Kilinochchi Police",
        "number": "0212288000",
        "category": "🏢 District Police",
        "district": "Kilinochchi",
      },
      {
        "name": "🏢 Paranthan Police",
        "number": "0212288111",
        "category": "🏢 District Police",
        "district": "Kilinochchi",
      },
    ]);

    // 13. Mannar District
    _allContacts.addAll([
      {
        "name": "🏢 Mannar Police",
        "number": "0232222222",
        "category": "🏢 District Police",
        "district": "Mannar",
      },
      {
        "name": "🏢 Pesalai Police",
        "number": "0232255555",
        "category": "🏢 District Police",
        "district": "Mannar",
      },
    ]);

    // 14. Mullaitivu District
    _allContacts.addAll([
      {
        "name": "🏢 Mullaitivu Police",
        "number": "0212299999",
        "category": "🏢 District Police",
        "district": "Mullaitivu",
      },
      {
        "name": "🏢 Oddusuddan Police",
        "number": "0212211111",
        "category": "🏢 District Police",
        "district": "Mullaitivu",
      },
    ]);

    // 15. Vavuniya District
    _allContacts.addAll([
      {
        "name": "🏢 Vavuniya Police",
        "number": "0242222222",
        "category": "🏢 District Police",
        "district": "Vavuniya",
      },
      {
        "name": "🏢 Omanthai Police",
        "number": "0242233333",
        "category": "🏢 District Police",
        "district": "Vavuniya",
      },
      {
        "name": "Vavuniya Ops Room",
        "number": "0242222223",
        "category": "🏢 District Police",
        "district": "Vavuniya",
      },
      {
        "name": "Vavuniya Emergency",
        "number": "0242222224",
        "category": "🏢 District Police",
        "district": "Vavuniya",
      },
    ]);

    // 16. Batticaloa District
    _allContacts.addAll([
      {
        "name": "🏢 Batticaloa Police",
        "number": "0652224412",
        "category": "🏢 District Police",
        "district": "Batticaloa",
      },
      {
        "name": "🏢 Kalawanchikudy Police",
        "number": "0652255555",
        "category": "🏢 District Police",
        "district": "Batticaloa",
      },
      {
        "name": "Batticaloa Emergency",
        "number": "0652224404",
        "category": "🏢 District Police",
        "district": "Batticaloa",
      },
    ]);

    // 17. Ampara District
    _allContacts.addAll([
      {
        "name": "🏢 Ampara Police",
        "number": "0632222222",
        "category": "🏢 District Police",
        "district": "Ampara",
      },
      {
        "name": "🏢 Kalmunai Police",
        "number": "0672223333",
        "category": "🏢 District Police",
        "district": "Ampara",
      },
      {
        "name": "Ampara Emergency",
        "number": "0632222321",
        "category": "🏢 District Police",
        "district": "Ampara",
      },
    ]);

    // 18. Trincomalee District
    _allContacts.addAll([
      {
        "name": "🏢 Trincomalee Police",
        "number": "0262222222",
        "category": "🏢 District Police",
        "district": "Trincomalee",
      },
      {
        "name": "🏢 Kantale Police",
        "number": "0262233333",
        "category": "🏢 District Police",
        "district": "Trincomalee",
      },
      {
        "name": "Kantale Ops Room",
        "number": "0262234222",
        "category": "🏢 District Police",
        "district": "Trincomalee",
      },
      {
        "name": "Kantale Emergency",
        "number": "0262234227",
        "category": "🏢 District Police",
        "district": "Trincomalee",
      },
      {
        "name": "Trincomalee Ops Room",
        "number": "0262222030",
        "category": "🏢 District Police",
        "district": "Trincomalee",
      },
    ]);

    // 19. Kurunegala District
    _allContacts.addAll([
      {
        "name": "🏢 Kurunegala Police",
        "number": "0372223222",
        "category": "🏢 District Police",
        "district": "Kurunegala",
      },
      {
        "name": "🏢 Kuliyapitiya Police",
        "number": "0372288888",
        "category": "🏢 District Police",
        "district": "Kurunegala",
      },
      {
        "name": "Kurunegala Ops Room",
        "number": "0372222229",
        "category": "🏢 District Police",
        "district": "Kurunegala",
      },
      {
        "name": "Kuliyapitiya Ops Room",
        "number": "0372281220",
        "category": "🏢 District Police",
        "district": "Kurunegala",
      },
    ]);

    // 20. Puttalam District
    _allContacts.addAll([
      {
        "name": "🏢 Puttalam Police",
        "number": "0322266666",
        "category": "🏢 District Police",
        "district": "Puttalam",
      },
      {
        "name": "🏢 Chilaw Police",
        "number": "0322223222",
        "category": "🏢 District Police",
        "district": "Puttalam",
      },
      {
        "name": "Chilaw Ops Room",
        "number": "0322220752",
        "category": "🏢 District Police",
        "district": "Puttalam",
      },
    ]);

    // 21. Anuradhapura District
    _allContacts.addAll([
      {
        "name": "🏢 Anuradhapura Police",
        "number": "0252222788",
        "category": "🏢 District Police",
        "district": "Anuradhapura",
      },
      {
        "name": "🏢 Kekirawa Police",
        "number": "0252288888",
        "category": "🏢 District Police",
        "district": "Anuradhapura",
      },
      {
        "name": "Anuradhapura Ops Room",
        "number": "0252222124",
        "category": "🏢 District Police",
        "district": "Anuradhapura",
      },
    ]);

    // 22. Polonnaruwa District
    _allContacts.addAll([
      {
        "name": "🏢 Polonnaruwa Police",
        "number": "0272222222",
        "category": "🏢 District Police",
        "district": "Polonnaruwa",
      },
      {
        "name": "🏢 Medirigiriya Police",
        "number": "0272233333",
        "category": "🏢 District Police",
        "district": "Polonnaruwa",
      },
      {
        "name": "Polonnaruwa Ops Room",
        "number": "0272222159",
        "category": "🏢 District Police",
        "district": "Polonnaruwa",
      },
    ]);

    // 23. Badulla District
    _allContacts.addAll([
      {
        "name": "🏢 Badulla Police",
        "number": "0552222219",
        "category": "🏢 District Police",
        "district": "Badulla",
      },
      {
        "name": "🏢 Bandarawela Police",
        "number": "0572223422",
        "category": "🏢 District Police",
        "district": "Badulla",
      },
    ]);

    // 24. Monaragala District
    _allContacts.addAll([
      {
        "name": "🏢 Monaragala Police",
        "number": "0552277777",
        "category": "🏢 District Police",
        "district": "Monaragala",
      },
      {
        "name": "🏢 Wellawaya Police",
        "number": "0552288888",
        "category": "🏢 District Police",
        "district": "Monaragala",
      },
      {
        "name": "Monaragala Ops Room",
        "number": "0552277316",
        "category": "🏢 District Police",
        "district": "Monaragala",
      },
    ]);

    // 25. Ratnapura District
    _allContacts.addAll([
      {
        "name": "🏢 Ratnapura Police",
        "number": "0452222222",
        "category": "🏢 District Police",
        "district": "Ratnapura",
      },
      {
        "name": "🏢 Embilipitiya Police",
        "number": "0472263223",
        "category": "🏢 District Police",
        "district": "Ratnapura",
      },
      {
        "name": "Ratnapura Ops Room",
        "number": "0452232222",
        "category": "🏢 District Police",
        "district": "Ratnapura",
      },
    ]);

    // 26. Kegalle District
    _allContacts.addAll([
      {
        "name": "🏢 Kegalle Police",
        "number": "0352222222",
        "category": "🏢 District Police",
        "district": "Kegalle",
      },
      {
        "name": "🏢 Mawanella Police",
        "number": "0352255555",
        "category": "🏢 District Police",
        "district": "Kegalle",
      },
      {
        "name": "Kegalle Ops Room",
        "number": "0352222674",
        "category": "🏢 District Police",
        "district": "Kegalle",
      },
      {
        "name": "Kegalle Emergency",
        "number": "0352222333",
        "category": "🏢 District Police",
        "district": "Kegalle",
      },
    ]);

    // 27. Range Offices
    _allContacts.addAll([
      {
        "name": "📡 Eastern Range South - Ampara",
        "number": "0632222321",
        "category": "📡 Range Offices",
        "district": "Ampara",
      },
      {
        "name": "📡 North Central Range - Anuradhapura",
        "number": "0252222788",
        "category": "📡 Range Offices",
        "district": "Anuradhapura",
      },
      {
        "name": "📡 Uva Range - Badulla",
        "number": "0552222219",
        "category": "📡 Range Offices",
        "district": "Badulla",
      },
      {
        "name": "📡 Eastern Range South - Batticaloa",
        "number": "0652224404",
        "category": "📡 Range Offices",
        "district": "Batticaloa",
      },
      {
        "name": "📡 Western Province North - Gampaha",
        "number": "0332222223",
        "category": "📡 Range Offices",
        "district": "Gampaha",
      },
      {
        "name": "📡 Central Range - Kandy",
        "number": "0812234337",
        "category": "📡 Range Offices",
        "district": "Kandy",
      },
      {
        "name": "📡 Eastern Range - Kantale",
        "number": "0262234222",
        "category": "📡 Range Offices",
        "district": "Trincomalee",
      },
      {
        "name": "📡 Sabaragamuwa Range - Kegalle",
        "number": "0352222674",
        "category": "📡 Range Offices",
        "district": "Kegalle",
      },
      {
        "name": "📡 Western Province North - Kelaniya",
        "number": "0112909990",
        "category": "📡 Range Offices",
        "district": "Colombo",
      },
      {
        "name": "📡 North Western Range - Kurunegala",
        "number": "0372222229",
        "category": "📡 Range Offices",
        "district": "Kurunegala",
      },
      {
        "name": "📡 Central Range West - Matale",
        "number": "0662224753",
        "category": "📡 Range Offices",
        "district": "Matale",
      },
      {
        "name": "📡 Southern Range - Matara",
        "number": "0412222213",
        "category": "📡 Range Offices",
        "district": "Matara",
      },
      {
        "name": "📡 Western Province South - Mount Lavinia",
        "number": "0112732916",
        "category": "📡 Range Offices",
        "district": "Colombo",
      },
      {
        "name": "📡 Western Province South - Nugegoda",
        "number": "0112852566",
        "category": "📡 Range Offices",
        "district": "Colombo",
      },
      {
        "name": "📡 Central Range East - Nuwara Eliya",
        "number": "0522222398",
        "category": "📡 Range Offices",
        "district": "Nuwara Eliya",
      },
      {
        "name": "📡 North Central Range - Polonnaruwa",
        "number": "0272222159",
        "category": "📡 Range Offices",
        "district": "Polonnaruwa",
      },
      {
        "name": "📡 Sabaragamuwa Range - Ratnapura",
        "number": "0452232222",
        "category": "📡 Range Offices",
        "district": "Ratnapura",
      },
      {
        "name": "📡 Southern Range - Tangalle",
        "number": "0472241013",
        "category": "📡 Range Offices",
        "district": "Hambantota",
      },
      {
        "name": "📡 Eastern Range North - Trincomalee",
        "number": "0262222030",
        "category": "📡 Range Offices",
        "district": "Trincomalee",
      },
      {
        "name": "📡 Wanni Range - Vavuniya",
        "number": "0242222223",
        "category": "📡 Range Offices",
        "district": "Vavuniya",
      },
    ]);

    // 28. Additional Range Ops Rooms
    _allContacts.addAll([
      {
        "name": "📡 Avissawella Emergency",
        "number": "0362222226",
        "category": "📡 Range Offices",
        "district": "Colombo",
      },
      {
        "name": "📡 Kelaniya Emergency",
        "number": "0112908888",
        "category": "📡 Range Offices",
        "district": "Colombo",
      },
      {
        "name": "📡 Moratuwa Emergency",
        "number": "0112645222",
        "category": "📡 Range Offices",
        "district": "Colombo",
      },
      {
        "name": "📡 Nikaweratiya Ops Room",
        "number": "0372260344",
        "category": "📡 Range Offices",
        "district": "Kurunegala",
      },
      {
        "name": "📡 Welikada Emergency",
        "number": "0115338844",
        "category": "📡 Range Offices",
        "district": "Colombo",
      },
      {
        "name": "📡 Panadura Ops Room",
        "number": "0382233228",
        "category": "📡 Range Offices",
        "district": "Kalutara",
      },
    ]);

    // 29. Senior Officers & Good Conduct Officers
    _allContacts.addAll([
      {
        "name": "👮 SDIG - Training & Higher Training",
        "number": "0718592621",
        "category": "👮 Officers & Units",
        "district": "HQ",
        "officer": "Medawatte S.C.",
      },
      {
        "name": "👮 SDIG - Special Protection Range",
        "number": "0718592643",
        "category": "👮 Officers & Units",
        "district": "HQ",
        "officer": "Karunanayake U.P.A.D.K.P.",
      },
      {
        "name": "👮 DIG - Special Branch Range",
        "number": "0718592647",
        "category": "👮 Officers & Units",
        "district": "HQ",
        "officer": "Sampath Kumara N.L.C.",
      },
      {
        "name": "👮 DIG - Logistics Range",
        "number": "0718598088",
        "category": "👮 Officers & Units",
        "district": "HQ",
        "officer": "De Silva W.S.P.",
      },
      {
        "name": "👮 DIG - CID (Act.)",
        "number": "0718598007",
        "category": "👮 Officers & Units",
        "district": "HQ",
        "officer": "Dayarathne M.D.P.",
      },
      {
        "name": "👮 DIG - STF Commandant",
        "number": "0718592680",
        "category": "👮 Officers & Units",
        "district": "HQ",
        "officer": "D.G.S. De Silva",
      },
      {
        "name": "👮 DIG - Research & IT",
        "number": "0718592682",
        "category": "👮 Officers & Units",
        "district": "HQ",
        "officer": "Senevirathna A.G.N.D.",
      },
      {
        "name": "👮 DIG - Children & Women",
        "number": "0718598015",
        "category": "👮 Officers & Units",
        "district": "HQ",
        "officer": "Kumari R.A.D.",
      },
      {
        "name": "👮 Director - Police College",
        "number": "0718591935",
        "category": "👮 Officers & Units",
        "district": "HQ",
        "officer": "Gunarathne C.",
      },
      {
        "name": "👮 Director - Traffic Admin",
        "number": "0718591967",
        "category": "👮 Officers & Units",
        "district": "HQ",
        "officer": "Manoj R.",
      },
      {
        "name": "👮 Director - HQ Admin",
        "number": "0718591854",
        "category": "👮 Officers & Units",
        "district": "HQ",
        "officer": "Herath A.G.U.C.",
      },
      {
        "name": "👮 Director - Transport",
        "number": "0718591970",
        "category": "👮 Officers & Units",
        "district": "HQ",
        "officer": "Sugath Kumara G.",
      },
    ]);

    // 30. Special Units and Divisions
    _allContacts.addAll([
      {
        "name": "🏛️ Special Investigation Unit",
        "number": "0753776395",
        "category": "👮 Officers & Units",
        "district": "Colombo",
        "officer": "K.D.C. Pathiraja",
      },
      {
        "name": "🏛️ Walana Central Anti-Corruption",
        "number": "0710316182",
        "category": "👮 Officers & Units",
        "district": "Colombo",
        "officer": "R.A. Janitha Kumara",
      },
      {
        "name": "🏛️ IGP Secretariat Division",
        "number": "0705037796",
        "category": "👮 Officers & Units",
        "district": "Colombo",
        "officer": "H.D.G Dayananda",
      },
      {
        "name": "🏛️ Media Division",
        "number": "0728192531",
        "category": "👮 Officers & Units",
        "district": "Colombo",
        "officer": "Abeyrathne",
      },
      {
        "name": "🏛️ Child & Women Bureau (ASP)",
        "number": "0718591723",
        "category": "👮 Officers & Units",
        "district": "Colombo",
        "officer": "Meril Ranjan Lamahewa",
      },
      {
        "name": "🏛️ Police Narcotics Bureau",
        "number": "0771347359",
        "category": "👮 Officers & Units",
        "district": "Colombo",
        "officer": "H.A.N Samarawickrama",
      },
      {
        "name": "🏛️ Police Marine Division",
        "number": "0719218626",
        "category": "👮 Officers & Units",
        "district": "Colombo",
        "officer": "K.M.P Wijesiri",
      },
      {
        "name": "🏛️ Police Tourism Division",
        "number": "0789776345",
        "category": "👮 Officers & Units",
        "district": "Colombo",
        "officer": "N.J.A Anulasiri",
      },
      {
        "name": "🏛️ Crime Reports Division",
        "number": "0112696413",
        "category": "👮 Officers & Units",
        "district": "Colombo",
        "officer": "M.K.A Meegoda",
      },
      {
        "name": "🏛️ Human Rights Division",
        "number": "0707707708",
        "category": "👮 Officers & Units",
        "district": "Colombo",
        "officer": "H.D.C.S Gunawardhane",
      },
      {
        "name": "🏛️ Police Hospital - Narahenpita",
        "number": "0702511355",
        "category": "👮 Officers & Units",
        "district": "Colombo",
        "officer": "M.D.W.S Wijewardhana",
      },
      {
        "name": "🏛️ Police Hospital - Kundasale",
        "number": "0773263283",
        "category": "👮 Officers & Units",
        "district": "Kandy",
        "officer": "G.L.C Sirikantha",
      },
    ]);

    // 31. Provincial Internal Affairs Units
    _allContacts.addAll([
      {
        "name": "🏛️ Western Province IAU",
        "number": "0112325843",
        "category": "👮 Officers & Units",
        "district": "Colombo",
        "officer": "Athula Gamage",
      },
      {
        "name": "🏛️ North Central IAU",
        "number": "0718596490",
        "category": "👮 Officers & Units",
        "district": "Anuradhapura",
        "officer": "S.M.R. Senanayake",
      },
      {
        "name": "🏛️ Uva Province IAU",
        "number": "0718292248",
        "category": "👮 Officers & Units",
        "district": "Badulla",
        "officer": "N.M. Karunapala",
      },
      {
        "name": "🏛️ Northern Province IAU",
        "number": "0212220008",
        "category": "👮 Officers & Units",
        "district": "Jaffna",
        "officer": "S. Sanjeew",
      },
      {
        "name": "🏛️ Sabaragamuwa IAU",
        "number": "07113439054",
        "category": "👮 Officers & Units",
        "district": "Ratnapura",
        "officer": "Sajeeva Ariyasena",
      },
      {
        "name": "🏛️ Southern Province IAU",
        "number": "0710416760",
        "category": "👮 Officers & Units",
        "district": "Matara",
        "officer": "Senaka Weerasinghe",
      },
      {
        "name": "🏛️ Central Province IAU",
        "number": "0714003187",
        "category": "👮 Officers & Units",
        "district": "Kandy",
        "officer": "Aruna Jayasinghe",
      },
      {
        "name": "🏛️ North Western IAU",
        "number": "0786496670",
        "category": "👮 Officers & Units",
        "district": "Kurunegala",
        "officer": "D.M.P.D.K. Dahanaka",
      },
      {
        "name": "🏛️ Eastern Province IAU",
        "number": "0718591129",
        "category": "👮 Officers & Units",
        "district": "Batticaloa",
        "officer": "A.L.M. Jemil",
      },
    ]);
  }

  List<Map<String, String>> get _filteredContacts {
    if (_searchController.text.isNotEmpty && _selectedCategory != 'All') {
      return _allContacts
          .where(
            (contact) =>
                contact["name"]!.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) &&
                contact["category"] == _selectedCategory,
          )
          .toList();
    } else if (_searchController.text.isNotEmpty) {
      return _allContacts
          .where(
            (contact) => contact["name"]!.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ),
          )
          .toList();
    } else if (_selectedCategory != 'All') {
      return _allContacts
          .where((contact) => contact["category"] == _selectedCategory)
          .toList();
    }
    return _allContacts;
  }

  Future<void> _makeCall(String number) async {
    String cleanNumber = number.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri url = Uri(scheme: 'tel', path: cleanNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not call $number')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sri Lanka Police Directory",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : 'All';
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.blue.shade100,
                    checkmarkColor: Colors.blue.shade800,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Search by name, district, or officer...",
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20,
                ),
              ),
            ),
          ),

          // Contact List
          Expanded(
            child: _filteredContacts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No contacts found",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getCategoryColor(
                              contact["category"],
                            ),
                            child: Icon(
                              _getCategoryIcon(contact["category"]),
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            contact["name"]!,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(contact["number"]!),
                              if (contact["district"] != null &&
                                  contact["district"] != "HQ")
                                Text(
                                  contact["district"]!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              if (contact["officer"] != null)
                                Text(
                                  "Officer: ${contact["officer"]}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.call, color: Colors.green),
                            onPressed: () => _makeCall(contact["number"]!),
                          ),
                          onTap: () => _makeCall(contact["number"]!),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case '🚨 Emergency':
        return Colors.red;
      case '🏢 District Police':
        return Colors.blue;
      case '📡 Range Offices':
        return Colors.orange;
      case '👮 Officers & Units':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case '🚨 Emergency':
        return Icons.emergency;
      case '🏢 District Police':
        return Icons.local_police;
      case '📡 Range Offices':
        return Icons.radio;
      case '👮 Officers & Units':
        return Icons.badge;
      default:
        return Icons.phone;
    }
  }
}
