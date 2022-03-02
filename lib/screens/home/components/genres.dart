import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:suggest_filmov/provider/provider_data.dart';

class GenresWidgets extends StatelessWidget {
  const GenresWidgets({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return SizedBox(
        height: 40,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.genres.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              width: 100,
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  data.genres[index].name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ));
  }
}
