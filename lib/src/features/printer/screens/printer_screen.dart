import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/constants.dart';
import '../../../core/utils.dart';
import '../../internet/bloc/internet_bloc.dart';
import '../../internet/widgets/no_internet.dart';
import '../../photo/screens/photo_screen.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/screens/vip_screen.dart';
import '../widgets/printer_card.dart';
import 'camera_screen.dart';
import 'documents_screen.dart';
import 'email_screen.dart';
import 'printables_screen.dart';
import 'web_pages_screen.dart';

class PrinterScreen extends StatelessWidget {
  const PrinterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, bool>(
      builder: (context, hasInternet) {
        if (!hasInternet) return const NoInternet();

        final isVip = context.watch<VipBloc>().state.isVip;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              PrinterCard(
                id: 1,
                title: 'Documents',
                description: 'Print any file instantly',
                onPressed: () async {
                  await pickFile().then(
                    (value) {
                      if (value != null && context.mounted) {
                        context.push(
                          DocumentsScreen.routePath,
                          extra: value,
                        );
                      }
                    },
                  );
                },
              ),
              PrinterCard(
                id: 2,
                title: 'Camera',
                description: 'Make a photo and print',
                onPressed: () async {
                  if (await Permission.camera.status.isGranted) {
                    await pickImage().then(
                      (value) {
                        if (value != null && context.mounted) {
                          context.push(
                            CameraScreen.routePath,
                            extra: value,
                          );
                        }
                      },
                    );
                  } else {
                    final result = await Permission.camera.request();
                    if (result.isPermanentlyDenied) {
                      openAppSettings();
                    }
                  }
                },
              ),
              PrinterCard(
                id: 3,
                title: 'Photo',
                description: 'Print photos from gallery',
                onPressed: () {
                  isVip
                      ? context.push(PhotoScreen.routePath)
                      : context.push(
                          VipScreen.routePath,
                          extra: Identifiers.paywall3,
                        );
                },
              ),
              PrinterCard(
                id: 4,
                title: 'Email',
                description: 'Print attachments easily',
                onPressed: () {
                  context.push(EmailScreen.routePath);
                },
              ),
              PrinterCard(
                id: 5,
                title: 'Web Pages',
                description: 'Print any website in full page',
                onPressed: () {
                  context.push(WebPagesScreen.routePath);
                },
              ),
              PrinterCard(
                id: 6,
                title: 'Printables',
                description: 'Cards, planners & more',
                onPressed: () {
                  isVip
                      ? context.push(PrintablesScreen.routePath)
                      : context.push(
                          VipScreen.routePath,
                          extra: Identifiers.paywall3,
                        );
                },
              ),
              PrinterCard(
                id: 9,
                title: 'Dropbox',
                description: 'Access your cloud files',
                onPressed: () async {
                  if (isVip) {
                    try {
                      if (!await launchUrl(
                        Uri.parse(Urls.url3),
                      )) {
                        throw 'Could not launch url';
                      }
                    } catch (e) {
                      logger(e);
                    }
                  } else {
                    context.push(
                      VipScreen.routePath,
                      extra: Identifiers.paywall3,
                    );
                  }
                },
              ),
              PrinterCard(
                id: 10,
                title: 'iCloud Drive',
                description: 'Print from your iCloud',
                onPressed: () async {
                  if (isVip) {
                    await pickFile().then(
                      (value) {
                        if (value != null && context.mounted) {
                          context.push(
                            DocumentsScreen.routePath,
                            extra: value,
                          );
                        }
                      },
                    );
                  } else {
                    context.push(
                      VipScreen.routePath,
                      extra: Identifiers.paywall3,
                    );
                  }
                },
              ),
              PrinterCard(
                id: 7,
                title: 'Invoice',
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.receipt_long,
                                  size: 32,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Invoice Maker',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Create beautiful invoices and estimates with our Invoice Maker app',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    try {
                                      if (!await launchUrl(
                                        Uri.parse(Urls.url1),
                                      )) {
                                        throw 'Could not launch url';
                                      }
                                    } catch (e) {
                                      logger(e);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    'Install',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // if (context.read<FirebaseBloc>().state.invoice) ...[
              // PrinterCard(
              //   id: 7,
              //   title: 'Invoice',
              //   onPressed: () async {
              //     try {
              //       if (!await launchUrl(
              //         Uri.parse(Urls.url1),
              //       )) {
              //         throw 'Could not launch url';
              //       }
              //     } catch (e) {
              //       logger(e);
              //     }
              //   },
              // ),
              // PrinterCard(
              //   id: 8,
              //   title: 'PDF',
              //   onPressed: () async {
              //     try {
              //       if (!await launchUrl(
              //         Uri.parse(Urls.url2),
              //       )) {
              //         throw 'Could not launch url';
              //       }
              //     } catch (e) {
              //       logger(e);
              //     }
              //   },
              // ),
              //   ],
            ],
          ),
        );
      },
    );
  }
}
