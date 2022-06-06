import 'package:bitirme_proje/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../providers/application_providers.dart';

class MyCustomListTile extends StatelessWidget {
  final Widget thumbnail;
  final String title;
  final String? description;
  final String author;
  final String? price;
  final Widget? currencyCode;

  const MyCustomListTile(
      {Key? key,
      required this.thumbnail,
      required this.title,
      this.description,
      required this.author,
      this.price,
      this.currencyCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 2, child: thumbnail),
          Expanded(
            flex: 4,
            child: _BookDescription(
              title: title,
              description: description ?? "-",
              author: author,
              price: price,
              currencyCode: currencyCode,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookDescription extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final String author;
  final String? price;
  final Widget? currencyCode;
  const _BookDescription(
      {Key? key,
      required this.title,
      required this.description,
      required this.author,
      this.price,
      this.currencyCode})
      : super(key: key);

  @override
  _BookDescriptionState createState() => _BookDescriptionState();
}

class _BookDescriptionState extends ConsumerState<_BookDescription> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              widget.title,
              style: isDarkMode
                  ? AppTheme.darkTheme.primaryTextTheme.bodyText2
                  : AppTheme.lightTheme.primaryTextTheme.bodyText2,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            widget.description,
            style: isDarkMode
                ? AppTheme.darkTheme.primaryTextTheme.caption
                : AppTheme.lightTheme.primaryTextTheme.caption,
            maxLines: 4,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          SizedBox(
            height: 20,
          ),
          Text(
            widget.author,
            style: isDarkMode
                ? AppTheme.darkTheme.primaryTextTheme.caption
                : AppTheme.lightTheme.primaryTextTheme.caption,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 4)],
                borderRadius: BorderRadius.circular(10),
                color: isDarkMode ? Colors.black : Colors.white),
            height: 7.h,
            width: 30.w,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.price == null ? "Ücretsiz" : widget.price!,
                    style: isDarkMode
                        ? AppTheme.darkTheme.primaryTextTheme.bodyText1
                        : AppTheme.lightTheme.primaryTextTheme.bodyText1,
                  ),
                  /* Text(
                    widget.currencyCode == null ? "-" : widget.currencyCode!,
                    style: isDarkMode
                        ? AppTheme.darkTheme.primaryTextTheme.bodyText1
                        : AppTheme.lightTheme.primaryTextTheme.bodyText1,
                  ), */
                  widget.currencyCode!
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
