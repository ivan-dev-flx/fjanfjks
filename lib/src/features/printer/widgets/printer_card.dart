import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/constants.dart';
import '../../../core/models/vip.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../vip/bloc/vip_bloc.dart';

class PrinterCard extends StatelessWidget {
  const PrinterCard({
    super.key,
    required this.id,
    required this.title,
    this.description = '',
    required this.onPressed,
  });

  final int id;
  final String title;
  final String description;
  final VoidCallback onPressed;

  String getAsset() {
    if (id == 1) return Assets.printer1;
    if (id == 2) return Assets.printer2;
    if (id == 3) return Assets.printer3;
    if (id == 4) return Assets.printer4;
    if (id == 5) return Assets.printer5;
    if (id == 6) return Assets.printer6;
    if (id == 7) return Assets.printer7;
    if (id == 9) return Assets.dropbox;
    if (id == 10) return Assets.icloud;
    return Assets.printer8;
  }

  List<Color> getColors() {
    if (id == 1) return const [Color(0xff5C9EFD), Color(0xff1A76FF)];
    if (id == 2) return const [Color(0xffFFA25C), Color(0xffFF5C00)];
    if (id == 3) return const [Color(0xffFDE200), Color(0xffF9B400)];
    if (id == 4) return const [Color(0xff37D6F3), Color(0xff0FBFEE)];
    if (id == 5) return const [Color(0xff28F2CA), Color(0xff14DEB6)];
    if (id == 6) return const [Color(0xff9F51FF), Color(0xff603199)];
    if (id == 7) return const [Color(0xff2D2D2D), Color(0xff1A1A1A)];
    if (id == 9) return const [Color(0xff536ED9), Color(0xff102880)];
    if (id == 10) return const [Color(0xffFF5CA9), Color(0xffD6006E)];
    return const [Color(0xffED2F22), Color(0xffB00B00)];
  }

  bool get isVipOnly => [3, 6, 9, 10].contains(id);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isIpad = width >= 500;
    final size = (width / (isIpad ? 3 : 2)) - (isIpad ? 22 : 24);

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: getColors(),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          BlocBuilder<VipBloc, Vip>(
            builder: (context, state) {
              return Button(
                onPressed: state.loading ? null : onPressed,
                child: id == 7
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/invoice_icon.png',
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 64,
                              width: 64,
                              child: SvgWidget(getAsset(), color: Colors.white),
                            ),
                            Text(
                              title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: AppFonts.inter600,
                              ),
                            ),
                            Text(
                              description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: AppFonts.inter400,
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
