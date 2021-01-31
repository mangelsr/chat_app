import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app/models/user.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final List<User> users = [
    User(uid: '1', name: 'Paty', email: 'test1@test.com', online: true),
    User(uid: '2', name: 'Angel', email: 'test2@test.com', online: false),
    User(uid: '3', name: 'David', email: 'test3@test.com', online: true),
  ];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My name',
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black54,
          ),
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.check_circle,
              color: Colors.blue[400],
            ),
            // child: Icon(
            //   Icons.offline_bolt,
            //   color: Colors.red,
            // ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: WaterDropHeader(
          complete: Icon(
            Icons.check,
            color: Colors.blue[400],
          ),
          waterDropColor: Colors.blue[400],
        ),
        child: _buildUsersListView(),
      ),
    );
  }

  ListView _buildUsersListView() => ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, int i) => _buildUserTile(users[i]),
        separatorBuilder: (_, __) => Divider(),
        itemCount: users.length,
      );

  ListTile _buildUserTile(User user) => ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          child: Text(user.name.substring(0, 2).toUpperCase()),
          backgroundColor: Colors.blue[200],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      );

  _loadUsers() async {
    await Future.delayed(Duration(seconds: 1));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
