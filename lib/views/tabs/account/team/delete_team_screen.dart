import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/dimensions.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';

class DeleteTeamScreen extends StatefulWidget {
  static const tag = '/deleteTeam';
  DeleteTeamScreen({Key? key}) : super(key: key);

  @override
  _DeleteTeamScreenState createState() => _DeleteTeamScreenState();
}

class _DeleteTeamScreenState extends State<DeleteTeamScreen> {
  int choiceID = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: Text('Delete the team'),
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Column(
          children: [
            Container(
              color: ColorResources.getPrimary(context),
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('This team will be permanently deleted from VPlay. You will lose the data related to this team. There is no going back!'),
                  16.height,
                  Text('Why do you want to delete this team?', style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600)),
                  16.height,
                  LabeledRadio(
                    groupValue: choiceID,
                    value: 1,
                    label: 'Team created by mistake',
                    onChanged: (v) {
                      setState(() => choiceID = v);
                    },
                  ),
                  LabeledRadio(
                    groupValue: choiceID,
                    value: 2,
                    label: 'The team does not exist anymore',
                    onChanged: (v) {
                      setState(() => choiceID = v);
                    },
                  ),
                  LabeledRadio(
                    groupValue: choiceID,
                    value: 3,
                    label: 'The team has another VPlay account',
                    onChanged: (v) {
                      setState(() => choiceID = v);
                    },
                  ),
                  LabeledRadio(
                    groupValue: choiceID,
                    value: 4,
                    label: 'Other',
                    onChanged: (v) {
                      setState(() => choiceID = v);
                    },
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: choiceID != 0 ? () {
                showKSConfirmDialog(context, message: 'Are you sure you want to delete your team?', onYesPressed: () {
                  dismissScreen(context);
                });
              } : null,
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.red[200];
                  }
                  return Colors.red;
                }),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: MaterialStateProperty.all(Size(0, 44)),
              ),
              child: Text('Delete the team', style: Theme.of(context).textTheme.bodyText1?.copyWith(color: whiteColor)),
            ),
          ],
        ),
      ),
    );
  }
}

class LabeledRadio extends StatelessWidget {
  final String label;
  final EdgeInsets padding;
  final int groupValue;
  final int value;
  final Function onChanged;

  const LabeledRadio({required this.label, this.padding = EdgeInsets.zero, required this.groupValue, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (value != groupValue) {
            onChanged(value);
          }
        },
        child: Padding(
          padding: padding,
          child: Row(
            children: <Widget>[
              Radio<int>(
                groupValue: groupValue,
                value: value,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (int? newValue) {
                  onChanged(newValue);
                },
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
