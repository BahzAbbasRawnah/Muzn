import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jhijri/_src/_jHijri.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = "User"; // Default value
        if (state is AuthAuthenticated) {
          userName = state.user.fullName; // Assuming fullName is a property of the user
        }else{
          userName=BlocProvider.of<AuthBloc>(context).userModel?.fullName??"";
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            color: Theme.of(context).primaryColor.withAlpha(100),
          ),
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(
                Icons.person,
                size: 30,
                color: Theme.of(context).iconTheme.color,
              ),
              backgroundColor:Colors.white,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('welcome'.trans(context)),
                Text(userName),
                

              ],
            ),
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 20,color: Theme.of(context).iconTheme.color),
                      SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          DateTime.now().toString().split(' ')[0] + ' مــ ',
                          style: Theme.of(context).textTheme.displaySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 20,color: Theme.of(context).iconTheme.color),
                      SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          JHijri(fDate: DateTime.now()).toString() + ' هــ ',
                                                  style: Theme.of(context).textTheme.displaySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}