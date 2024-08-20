import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jam_it/core/theme/app_pallete.dart';
import 'package:jam_it/core/utils/utils.dart';
import 'package:jam_it/core/widgets/Loader/loader.dart';
import 'package:jam_it/core/widgets/custom_field.dart';
import 'package:jam_it/features/home/view/widgets/audio_wave.dart';
import 'package:jam_it/features/home/viewmodel/home_viewmodel.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final TextEditingController songNameController = TextEditingController();
  final TextEditingController artistNameController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? seletedAudio;
  final formKey = GlobalKey<FormState>();

  void selectImage() async {
    selectedImage = await pickImage();
    setState(() {});
  }

  void selectAudio() async {
    seletedAudio = await pickAudio();
    setState(() {});
  }

  @override
  void dispose() {
    songNameController.dispose();
    artistNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewModelProvider.select((val) => val?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  seletedAudio != null &&
                  selectedImage != null) {
                ref.read(homeViewModelProvider.notifier).uploadSong(
                      audio: seletedAudio!,
                      image: selectedImage!,
                      songName: songNameController.text,
                      artist: artistNameController.text,
                      color: selectedColor,
                    );
              } else {
                snackBarPopUp(context, 'Missing Fields');
              }
            },
            icon: const Icon(Icons.upload),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      selectedImage != null
                          ? SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: selectImage,
                              child: DottedBorder(
                                radius: const Radius.circular(10),
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                color: Pallete.borderColor,
                                dashPattern: const [22, 4],
                                child: const SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(height: 12),
                                      Text('Select the thumbnail')
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 40),
                      seletedAudio != null
                          ? AudioWave(path: seletedAudio!.path)
                          : CustomField(
                              hintext: 'Pick Song',
                              isReadOnly: true,
                              onTap: selectAudio,
                            ),
                      const SizedBox(height: 10),
                      CustomField(
                        hintext: 'Artist',
                        controller: artistNameController,
                      ),
                      const SizedBox(height: 10),
                      CustomField(
                        hintext: 'Song Name',
                        controller: songNameController,
                      ),
                      const SizedBox(height: 18),
                      ColorPicker(
                        pickersEnabled: const {ColorPickerType.wheel: true},
                        color: selectedColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
