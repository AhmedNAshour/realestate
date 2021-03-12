import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realestate/components/lists_cards/appointmentCard.dart';
import 'package:realestate/models/request.dart';
import 'package:realestate/sizeConfig.dart';
import 'package:sliding_card/sliding_card.dart';

class AppointmentRequestsListAdmin extends StatefulWidget {
  @override
  _AppointmentRequestsListAdminState createState() =>
      _AppointmentRequestsListAdminState();
}

class _AppointmentRequestsListAdminState
    extends State<AppointmentRequestsListAdmin> {
  SlidingCardController controller;
  @override
  void initState() {
    super.initState();
    controller = SlidingCardController();
  }

  @override
  Widget build(BuildContext context) {
    List<Request> requests = Provider.of<List<Request>>(context) ?? [];
    SizeConfig().init(context);

    requests.sort((a, b) {
      var aTitle = a.date; //before -> var adate = a.expiry;
      var bTitle = b.date; //before -> var bdate = b.expiry;
      return aTitle.compareTo(
          bTitle); //to get the order other way just switch `adate & bdate`
    });
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        return AppointmentCard(
          request: requests[index],
        );
      },
    );
  }
}
