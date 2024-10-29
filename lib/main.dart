import 'package:flutter/material.dart';
import 'package:lab1/post.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

void main() {
  runApp(
    MaterialApp(
      title: 'Lab1',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const FirstScreen(),
        // When navigating to the "/second" route, build the Home widget.
        '/home': (context) => const Home(),
      },
    ),
  );
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
      ),
      body: Center(
        child: ElevatedButton(
          // Within the `FirstScreen` widget
          onPressed: () {
            // Navigate to the second screen using a named route.
            Navigator.pushNamed(context, '/home');
          },
          child: const Text('Next'),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // variable to call and store future list of posts
  Future<List<Post>> postsFuture = getPosts();
  Future<List<Comment>> commentsFuture = getComments();

  // function to fetch data from api and return future list of posts
  static Future<List<Post>> getPosts() async {
    var url1 = Uri.parse(
        "https://jsonplaceholder.typicode.com/photos?_start=0&_limit=5");
    final response1 =
        await http.get(url1, headers: {"Content-Type": "application/json"});

    final List body1 = json.decode(response1.body);
    var part1 = body1.map((e) => Post.fromJson(e)).toList();
    return part1;
  }

  static Future<List<Comment>> getComments() async {
    var url2 = Uri.parse(
        "https://jsonplaceholder.typicode.com/comments?_start=0&_limit=5");
    final response2 =
        await http.get(url2, headers: {"Content-Type": "application/json"});

    final List body2 = json.decode(response2.body);
    var part2 = body2.map((e) => Comment.fromJson(e)).toList();
    return part2;
  }

  // build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        // FutureBuilder
        child: FutureBuilder<List<Post>>(
          future: postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // until data is fetched, show loader
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              // once data is fetched, display it on screen (call buildPosts())
              final posts = snapshot.data!;
              return buildPosts(posts);
            } else {
              // if no data, show simple Text
              return const Text("No data available");
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          // Within the Home widget
          onPressed: () {
            // Navigate back to the first screen by popping the current route
            // off the stack.
            Navigator.pop(context);
          },
          child: const Text('Back'),
        ),
      ),
    );
  }

  // function to display fetched data on screen
  Widget buildPosts(List<Post> posts) {
    // ListView Builder to show data in a list
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Container(
          color: Colors.grey.shade300,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 100,
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(flex: 1, child: Image.network(post.url!)),
              const SizedBox(width: 10),
              Expanded(flex: 3, child: Text(post.title!)),
            ],
          ),
        );
      },
    );
  }
}
