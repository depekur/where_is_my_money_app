import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/app_provider.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NewCategoryForm extends StatefulWidget {
  static const route = '/category-form';

  final Category? category;

  const NewCategoryForm({Key? key, this.category}) : super(key: key);

  @override
  State<NewCategoryForm> createState() => _NewCategoryFormState();
}

class _NewCategoryFormState extends State<NewCategoryForm> {
  bool _loading = false;
  var _nameLength = 0;
  var _nameMaxLength = 30;
  Category _category = Category.empty();
  final _form = GlobalKey<FormState>();

  bool get isEditing {
    return widget.category != null && widget.category!.id.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      _category = Category(
        name: widget.category!.name,
        id: widget.category!.id,
        color: widget.category!.color,
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.left,
      ),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    ));
  }

  void _save(context) async {
    final isValid = _form.currentState!.validate();

    if (!isValid || _loading) {
      return;
    }

    setState(() {
      _loading = true;
    });

    final appProvider = Provider.of<AppProvider>(context, listen: false);

    if (!isEditing) {
      try {
        await appProvider.addCategory(_category);

        _showSnackBar('Нова категорія додана');

        Navigator.of(context).pop();
      } catch (err) {
        _showSnackBar(
            'Отакої! Шось пішло не так. Спробуйте ще раз трохи пізьніше');
      } finally {
        setState(() {
          _loading = false;
        });
      }
    } else {
      try {
        await appProvider.updateCategory(_category);
        _showSnackBar('Назва категорії успішно змінена');
        Navigator.of(context).pop();
      } catch (e) {
        _showSnackBar(
            'От халепа! Шось пішло не так. Спробуйте ще раз трохи пізьніше');
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _openColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _category.color,
              onColorChanged: (color) {
                setState(() {
                  _category = Category(
                      id: _category.id,
                      name: _category.name,
                      color: color
                  );
                });
              },
              colorPickerWidth: 300,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: false,
              displayThumbColor: true,
              paletteType: PaletteType.hsvWithHue,
              labelTypes: const [],
              pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
              // hexInputController: textController,
              portraitOnly: true,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редагувати категорію' : 'Створити категорію'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _form,
              onChanged: () {
                Form.of(primaryFocus!.context!)!.save();
              },
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 30,
                    enabled: !_loading,
                    initialValue: _category.name,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Потрібно заповнити назву категорії';
                      } else if (val.length >= 30) {
                        return 'Занадто довга назва :(';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Назва категорії',
                        // helperText: 'Наприклад "Зарплатна картка" або "Заначка". ',
                        counterText: '$_nameLength/$_nameMaxLength'),
                    textInputAction: TextInputAction.next,
                    onChanged: (val) {
                      setState(() {
                        _nameLength = val.length;
                      });
                    },
                    onSaved: (val) {
                      if (val != null) {
                        _category = Category(
                          id: _category.id,
                          name: val,
                          color: _category.color,
                        );
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _openColorPickerDialog,
                        child: const Text('Вибрати колір'),
                      ),
                      CircleAvatar(
                        backgroundColor: _category.color,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () {
                            _save(context);
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save),
                        const SizedBox(width: 10),
                        Text(isEditing
                            ? 'Оновити категорію'
                            : 'Створити категорію'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
