import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const AmlakApp());
}

class AmlakApp extends StatelessWidget {
  const AmlakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مدیریت املاک',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Tahoma',
      ),
      home: const AmlakHomeScreen(),
    );
  }
}

class Property {
  final String fileCode;
  final String type; // فروش یا رهن و اجاره
  final String title;
  final String ownerName;
  final String meterage;
  final String price; // قیمت کل برای فروش
  final String deposit; // ودیعه (رهن)
  final String rent; // اجاره ماهانه
  final String phone;
  final String buildYear;
  final String floor;
  final String unitsPerFloor;
  final String bedrooms;
  final String direction;
  final String address;
  final String description;
  final bool hasElevator;
  final bool hasParking;
  final bool hasStorage;
  final bool hasBalcony;

  Property({
    required this.fileCode,
    required this.type,
    required this.title,
    required this.ownerName,
    required this.meterage,
    required this.price,
    required this.deposit,
    required this.rent,
    required this.phone,
    required this.buildYear,
    required this.floor,
    required this.unitsPerFloor,
    required this.bedrooms,
    required this.direction,
    required this.address,
    required this.description,
    required this.hasElevator,
    required this.hasParking,
    required this.hasStorage,
    required this.hasBalcony,
  });

  Map<String, dynamic> toJson() => {
        'fileCode': fileCode,
        'type': type,
        'title': title,
        'ownerName': ownerName,
        'meterage': meterage,
        'price': price,
        'deposit': deposit,
        'rent': rent,
        'phone': phone,
        'buildYear': buildYear,
        'floor': floor,
        'unitsPerFloor': unitsPerFloor,
        'bedrooms': bedrooms,
        'direction': direction,
        'address': address,
        'description': description,
        'hasElevator': hasElevator,
        'hasParking': hasParking,
        'hasStorage': hasStorage,
        'hasBalcony': hasBalcony,
      };

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        fileCode: json['fileCode'] ?? '',
        type: json['type'] ?? 'فروش',
        title: json['title'] ?? '',
        ownerName: json['ownerName'] ?? '',
        meterage: json['meterage'] ?? '',
        price: json['price'] ?? '',
        deposit: json['deposit'] ?? '',
        rent: json['rent'] ?? '',
        phone: json['phone'] ?? '',
        buildYear: json['buildYear'] ?? '',
        floor: json['floor'] ?? '',
        unitsPerFloor: json['unitsPerFloor'] ?? '',
        bedrooms: json['bedrooms'] ?? '',
        direction: json['direction'] ?? '',
        address: json['address'] ?? '',
        description: json['description'] ?? '',
        hasElevator: json['hasElevator'] ?? false,
        hasParking: json['hasParking'] ?? false,
        hasStorage: json['hasStorage'] ?? false,
        hasBalcony: json['hasBalcony'] ?? false,
      );
}

class AmlakHomeScreen extends StatefulWidget {
  const AmlakHomeScreen({super.key});

  @override
  State<AmlakHomeScreen> createState() => _AmlakHomeScreenState();
}

class _AmlakHomeScreenState extends State<AmlakHomeScreen> {
  List<Property> _allProperties = [];
  String _searchCode = '';
  String _selectedCategory = 'همه';

  String _dealType = 'فروش';
  final _titleController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _meterController = TextEditingController();
  final _priceController = TextEditingController();
  final _depositController = TextEditingController();
  final _rentController = TextEditingController();
  final _phoneController = TextEditingController();
  final _buildYearController = TextEditingController();
  final _floorController = TextEditingController();
  final _unitsController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _directionController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _hasElevator = false;
  bool _hasParking = false;
  bool _hasStorage = false;
  bool _hasBalcony = false;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final prefs = await SharedPreferences.getInstance();
    final String? propertiesString = prefs.getString('saved_properties');
    if (propertiesString != null) {
      final List<dynamic> decodedList = jsonDecode(propertiesString);
      setState(() {
        _allProperties = decodedList.map((item) => Property.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveProperties() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_allProperties.map((p) => p.toJson()).toList());
    await prefs.setString('saved_properties', encodedData);
  }

  String _generateFileCode() {
    return (1000 + Random().nextInt(9000)).toString();
  }

  void _addProperty() {
    if (_titleController.text.isEmpty) return;

    setState(() {
      _allProperties.add(
        Property(
          fileCode: _generateFileCode(),
          type: _dealType,
          title: _titleController.text,
          ownerName: _ownerNameController.text,
          meterage: _meterController.text,
          price: _priceController.text,
          deposit: _depositController.text,
          rent: _rentController.text,
          phone: _phoneController.text,
          buildYear: _buildYearController.text,
          floor: _floorController.text,
          unitsPerFloor: _unitsController.text,
          bedrooms: _bedroomsController.text,
          direction: _directionController.text,
          address: _addressController.text,
          description: _descriptionController.text,
          hasElevator: _hasElevator,
          hasParking: _hasParking,
          hasStorage: _hasStorage,
          hasBalcony: _hasBalcony,
        ),
      );
    });

    _saveProperties();
    _clearForm();
    Navigator.of(context).pop();
  }

  void _deleteProperty(String code) {
    setState(() {
      _allProperties.removeWhere((item) => item.fileCode == code);
    });
    _saveProperties();
  }

  void _clearForm() {
    _titleController.clear();
    _ownerNameController.clear();
    _meterController.clear();
    _priceController.clear();
    _depositController.clear();
    _rentController.clear();
    _phoneController.clear();
    _buildYearController.clear();
    _floorController.clear();
    _unitsController.clear();
    _bedroomsController.clear();
    _directionController.clear();
    _addressController.clear();
    _descriptionController.clear();
    _hasElevator = false;
    _hasParking = false;
    _hasStorage = false;
    _hasBalcony = false;
    _dealType = 'فروش';
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('ثبت فایل ملک جدید', textAlign: TextAlign.right),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _dealType,
                    decoration: const InputDecoration(labelText: 'نوع معامله'),
                    items: const [
                      DropdownMenuItem(value: 'فروش', child: Text('فروش')),
                      DropdownMenuItem(value: 'رهن و اجاره', child: Text('رهن و اجاره')),
                    ],
                    onChanged: (val) => setDialogState(() => _dealType = val!),
                  ),
                  TextField(controller: _titleController, textAlign: TextAlign.right, decoration: const InputDecoration(labelText: 'عنوان فایل')),
                  TextField(controller: _ownerNameController, textAlign: TextAlign.right, decoration: const InputDecoration(labelText: 'نام مالک')),
                  TextField(controller: _meterController, textAlign: TextAlign.right, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'متراژ')),
                  
                  // شرط کادرهای قیمت بر اساس نوع معامله
                  if (_dealType == 'فروش') ...[
                    TextField(controller: _priceController, textAlign: TextAlign.right, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'قیمت کل (تومان)')),
                  ] else ...[
                    TextField(controller: _depositController, textAlign: TextAlign.right, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'مبلغ ودیعه / رهن (تومان)')),
                    TextField(controller: _rentController, textAlign: TextAlign.right, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'اجاره ماهانه (تومان)')),
                  ],

                  TextField(controller: _phoneController, textAlign: TextAlign.right, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'شماره تماس مالک')),
                  TextField(controller: _buildYearController, textAlign: TextAlign.right, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'سال ساخت')),
                  TextField(controller: _floorController, textAlign: TextAlign.right, decoration: const InputDecoration(labelText: 'طبقه (چند از چند)')),
                  TextField(controller: _unitsController, textAlign: TextAlign.right, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'تعداد واحد در هر طبقه')),
                  TextField(controller: _bedroomsController, textAlign: TextAlign.right, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'تعداد خواب')),
                  TextField(controller: _directionController, textAlign: TextAlign.right, decoration: const InputDecoration(labelText: 'جهت ملک (شمالی/جنوبی و...)')),
                  TextField(controller: _addressController, textAlign: TextAlign.right, decoration: const InputDecoration(labelText: 'آدرس')),
                  TextField(controller: _descriptionController, textAlign: TextAlign.right, maxLines: 2, decoration: const InputDecoration(labelText: 'توضیحات تکمیلی')),
                  const SizedBox(height: 15),
                  const Text('امکانات ملک:', style: TextStyle(fontWeight: FontWeight.bold)),
                  CheckboxListTile(
                    title: const Text('آسانسور'),
                    value: _hasElevator,
                    onChanged: (val) => setDialogState(() => _hasElevator = val!),
                  ),
                  CheckboxListTile(
                    title: const Text('پارکینگ'),
                    value: _hasParking,
                    onChanged: (val) => setDialogState(() => _hasParking = val!),
                  ),
                  CheckboxListTile(
                    title: const Text('انباری'),
                    value: _hasStorage,
                    onChanged: (val) => setDialogState(() => _hasStorage = val!),
                  ),
                  CheckboxListTile(
                    title: const Text('بالکن'),
                    value: _hasBalcony,
                    onChanged: (val) => setDialogState(() => _hasBalcony = val!),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('انصراف')),
              ElevatedButton(onPressed: _addProperty, child: const Text('ثبت فایل')),
            ],
          );
        },
      ),
    );
  }

  List<Property> get _filteredProperties {
    return _allProperties.where((item) {
      final matchesSearch = _searchCode.isEmpty || item.fileCode.contains(_searchCode);
      final matchesCategory = _selectedCategory == 'همه' || item.type == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredProperties;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('پنل مدیریت املاک بابا'),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'جستجو با کد فایل (۴ رقمی)...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (val) => setState(() => _searchCode = val),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['همه', 'فروش', 'رهن و اجاره'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: Colors.indigo,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
            const Divider(),
            Expanded(
              child: filteredList.isEmpty
                  ? const Center(child: Text('هیچ فایلی پیدا نشد!'))
                  : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (ctx, index) {
                        final item = filteredList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: item.type == 'فروش' ? Colors.green : Colors.orange,
                              child: Text(item.type == 'فروش' ? 'فروش' : 'رهن', style: const TextStyle(fontSize: 10, color: Colors.white)),
                            ),
                            title: Text('${item.title} (کد: ${item.fileCode})', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              item.type == 'فروش'
                                  ? 'قیمت کل: ${item.price} تومان | متراژ: ${item.meterage} متر'
                                  : 'رهن: ${item.deposit} | اجاره: ${item.rent} | متراژ: ${item.meterage} متر',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _deleteProperty(item.fileCode),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('👤 نام مالک: ${item.ownerName}'),
                                    Text('📞 تماس مالک: ${item.phone}'),
                                    Text('📅 سال ساخت: ${item.buildYear} | 🛏 تعداد خواب: ${item.bedrooms}'),
                                    Text('🏢 طبقه: ${item.floor} | 🚪 واحد در طبقه: ${item.unitsPerFloor}'),
                                    Text('🧭 جهت ملک: ${item.direction}'),
                                    Text('📍 آدرس: ${item.address}'),
                                    const SizedBox(height: 5),
                                    Text('✨ امکانات: '
                                        'آسانسور: ${item.hasElevator ? "✅" : "❌"} | '
                                        'پارکینگ: ${item.hasParking ? "✅" : "❌"} | '
                                        'انباری: ${item.hasStorage ? "✅" : "❌"} | '
                                        'بالکن: ${item.hasBalcony ? "✅" : "❌"}'),
                                    if (item.description.isNotEmpty) ...[
                                      const SizedBox(height: 5),
                                      Text('📝 توضیحات: ${item.description}'),
                                    ]
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddDialog,
          label: const Text('ثبت فایل جدید'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.indigo,
        ),
      ),
    );
  }
}
