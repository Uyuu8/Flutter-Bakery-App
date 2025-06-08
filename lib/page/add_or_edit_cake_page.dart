import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:sweet_delights/models/cake_model.dart';
import 'package:sweet_delights/providers/cake_provider.dart';
import 'package:sweet_delights/data/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddOrEditCakePage extends StatefulWidget {
  final CakeModel? cake;

  const AddOrEditCakePage({this.cake, Key? key}) : super(key: key);

  @override
  State<AddOrEditCakePage> createState() => _AddOrEditCakePageState();
}

class _AddOrEditCakePageState extends State<AddOrEditCakePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController flavourCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController bgColorCtrl;
  late TextEditingController descCtrl;
  late TextEditingController ratingCtrl;
  late TextEditingController imageUrlCtrl;

  bool _isUploading = false;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final cake = widget.cake;

    nameCtrl = TextEditingController(text: cake?.name ?? '');
    flavourCtrl = TextEditingController(text: cake?.flavour ?? '');
    priceCtrl = TextEditingController(text: cake?.price.toString() ?? '');
    bgColorCtrl = TextEditingController(text: cake?.bgColor ?? '#FFFFFF');
    descCtrl = TextEditingController(text: cake?.description ?? '');
    ratingCtrl = TextEditingController(text: cake?.rating.toString() ?? '');
    imageUrlCtrl = TextEditingController(text: cake?.image ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    flavourCtrl.dispose();
    priceCtrl.dispose();
    bgColorCtrl.dispose();
    descCtrl.dispose();
    ratingCtrl.dispose();
    imageUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
  setState(() => _isUploading = true);

  try {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dg74e6khm/image/upload');

    http.MultipartRequest request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'flutter_unsigned';

    if (kIsWeb) {
      // Web: pakai file_picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result == null || result.files.first.bytes == null) {
        setState(() => _isUploading = false);
        return;
      }

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          result.files.first.bytes!,
          filename: result.files.first.name,
        ),
      );
    } else {
      // Android/iOS: pakai image_picker
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        setState(() => _isUploading = false);
        return;
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          pickedFile.path,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonRes = json.decode(response.body);
      setState(() {
        imageUrlCtrl.text = jsonRes['secure_url'];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gambar berhasil diupload')),
      );
    } else {
      throw Exception('Upload gagal: ${response.statusCode}\n${response.body}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Upload gagal: $e')),
    );
  } finally {
    setState(() => _isUploading = false);
  }
}


  String? _validateHexColor(String? value) {
    final hexColorRegExp = RegExp(r'^#(?:[0-9a-fA-F]{6})$');
    if (value == null || !hexColorRegExp.hasMatch(value)) {
      return 'Gunakan format HEX seperti #FFFFFF';
    }
    return null;
  }

  void _saveCake() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final cake = CakeModel(
        id: widget.cake?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameCtrl.text,
        flavour: flavourCtrl.text,
        image: imageUrlCtrl.text,
        price: double.tryParse(priceCtrl.text) ?? 0.0,
        bgColor: bgColorCtrl.text,
        description: descCtrl.text,
        rating: double.tryParse(ratingCtrl.text) ?? 0.0,
      );

      final provider = Provider.of<CakeProvider>(context, listen: false);
      if (widget.cake == null) {
        await provider.addCake(cake);
      } else {
        await provider.updateCake(cake);
      }

      Navigator.pop(context); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.cake == null ? 'Cake ditambahkan' : 'Cake diperbarui')),
      );

      Navigator.pop(context); // Close page
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.cake != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Cake' : 'Add Cake'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isUploading ? null : _saveCake,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _pickAndUploadImage,
                icon: const Icon(Icons.photo_library),
                label: const Text("Pilih Gambar dari Galeri"),
              ),
              const SizedBox(height: 12),
              _buildImagePreview(),
              _buildImageUrlField(),
              _buildTextField(nameCtrl, 'Cake Name'),
              _buildFlavourDropdown(),
              _buildTextField(priceCtrl, 'Price', isNumber: true),
              _buildTextField(descCtrl, 'Description', maxLines: 3),
              _buildTextField(ratingCtrl, 'Rating (0.0 - 5.0)', isNumber: true),
              Visibility(
                visible: false,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: _buildTextField(
                  bgColorCtrl,
                  'Background Color (#xxxxxx)',
                  validator: _validateHexColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUrlField() {
    return TextFormField(
      controller: imageUrlCtrl,
      readOnly: true,
      onChanged: (_) => setState(() {}),
      decoration: const InputDecoration(
        labelText: 'Image URL (otomatis setelah upload)',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Silakan upload gambar';
        }
        return null;
      },
    );
  }

  Widget _buildImagePreview() {
    Color backgroundColor;
    try {
      backgroundColor = Color(int.parse(bgColorCtrl.text.replaceAll('#', '0xFF')));
    } catch (_) {
      backgroundColor = Colors.grey[200]!;
    }

    return Container(
      height: 150,
      color: backgroundColor,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 12),
      child: imageUrlCtrl.text.isEmpty
          ? const Text('Belum ada gambar')
          : Image.network(
              imageUrlCtrl.text,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircularProgressIndicator();
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Text('URL gambar tidak valid'),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false,
      int maxLines = 1,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        validator: validator ??
            (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildFlavourDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: flavourCtrl.text.isNotEmpty ? flavourCtrl.text : null,
        decoration: const InputDecoration(
          labelText: 'Flavour',
          border: OutlineInputBorder(),
        ),
        items: categories
            .where((cat) => cat.tag != 'all')
            .map((category) => DropdownMenuItem<String>(
                  value: category.tag,
                  child: Text(category.name),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              flavourCtrl.text = value;
            });
          }
        },
        validator: (value) =>
            value == null || value.isEmpty ? 'Pilih flavour' : null,
      ),
    );
  }
}
