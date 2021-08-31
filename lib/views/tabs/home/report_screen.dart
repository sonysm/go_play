import 'package:flutter/material.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<String> problemList = [
    'Violence',
    'Harassment',
    'False Information',
    'Spam',
    'Hate Speech',
    'Unrelated Topic'
  ];

  String? problemSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: AppSize(context).appWidth(100),
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info),
              8.height,
              Text(
                'Please select a problem to continue',
                style: Theme.of(context).textTheme.headline6,
              ),
              4.height,
              Text(
                'You can report the post after selecting a problem',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              8.height,
              Wrap(
                children: problemList.map(
                  (e) {
                    return InkWell(
                      onTap: () {
                        if (problemSelected == e) {
                          problemSelected = null;
                        } else {
                          problemSelected = e;
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: isLight(context)
                              ? problemSelected != e
                                  ? Colors.grey[100]
                                  : mainColor
                              : problemSelected != e
                                  ? Colors.blueGrey[400]
                                  : mainColor,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          e,
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                  color: problemSelected != e
                                      ? isLight(context)
                                          ? blackColor
                                          : whiteColor
                                      : whiteColor),
                        ),
                      ),
                    );
                  },
                ).toList(),
                runSpacing: 8.0,
                spacing: 8.0,
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ElevatedButton(
              onPressed: problemSelected != null
                  ? () {
                      showKSLoading(context);
                      Future.delayed(Duration(milliseconds: 700)).then((_) {
                        dismissScreen(context);
                        dismissScreen(context, true);
                      });
                    }
                  : null,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 8.0)),
                elevation: MaterialStateProperty.all(0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: MaterialStateProperty.all(
                    problemSelected != null ? whiteColor : Colors.grey),
                backgroundColor: MaterialStateProperty.all(
                    problemSelected != null ? mainColor : Colors.grey[200]),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0))),
              ),
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showReportScreen(BuildContext context) async {
  await showMaterialModalBottomSheet<bool>(
    context: context,
    builder: (context) => Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Report'),
          centerTitle: true,
          elevation: 0.5,
          leading: IconButton(
              onPressed: () {
                dismissScreen(context, false);
              },
              icon: Icon(Icons.close)),
        ),
        body: ReportScreen(),
      ),
    ),
  ).then((value) {
    if (value != null && value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You report a post.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black87,
        ),
      );
    }
  });
}
