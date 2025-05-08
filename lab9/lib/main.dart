import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

class Post {
  final int id;
  String title;
  String body;

  Post({required this.id, required this.title, required this.body});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local CRUD App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [
    User(id: 1, name: "Iqra Jan", email: "iqra@example.com"),
    User(id: 2, name: "gul Khan", email: "gul@example.com"),
  ];

  List<Post> posts = [
    Post(id: 1, title: "First Post", body: "This is the first post."),
    Post(id: 2, title: "Second Post", body: "This is the second post."),
  ];

  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  void showPostForm({Post? post}) {
    if (post != null) {
      titleController.text = post.title;
      bodyController.text = post.body;
    } else {
      titleController.clear();
      bodyController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(post == null ? 'Add Post' : 'Edit Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Body'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final title = titleController.text;
              final body = bodyController.text;

              if (post == null) {
                setState(() {
                  posts.add(Post(
                    id: posts.length + 1,
                    title: title,
                    body: body,
                  ));
                });
              } else {
                setState(() {
                  post.title = title;
                  post.body = body;
                });
              }

              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void deletePost(int id) {
    setState(() {
      posts.removeWhere((post) => post.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('CRUD with Hardcoded Data'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Posts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Users Tab
            ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            ),
            // Posts Tab
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (_, index) {
                      final post = posts[index];
                      return ListTile(
                        title: Text(post.title),
                        subtitle: Text(post.body),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => showPostForm(post: post),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => deletePost(post.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => showPostForm(),
                    child: Text('Add Post'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
