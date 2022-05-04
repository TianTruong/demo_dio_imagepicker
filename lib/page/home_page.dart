import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:demo_dio_imagepicker/model/model.dart';
import 'package:demo_dio_imagepicker/page/information_page.dart';
import 'package:demo_dio_imagepicker/constants/constants.dart';
import 'package:demo_dio_imagepicker/client/post_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;

  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() => this.image = imageTemporary);
  }

  PostClient postClient = PostClient();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Center(
              child: ClipOval(
                child: image != null
                    ? InkWell(
                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                          cacheHeight: 160,
                          cacheWidth: 160,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text('Camera'),
                                          onTap: () => Navigator.of(context)
                                              .pop(
                                                  getImage(ImageSource.camera)),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.image),
                                          title: const Text('Gallery'),
                                          onTap: () => Navigator.of(context)
                                              .pop(getImage(
                                                  ImageSource.gallery)),
                                        )
                                      ],
                                    ),
                                  ));
                        },
                      )
                    : InkWell(
                        child: Image.asset(
                          'images/intro.jpg',
                          fit: BoxFit.cover,
                          cacheHeight: 160,
                          cacheWidth: 160,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text('Camera'),
                                          onTap: () => Navigator.of(context)
                                              .pop(
                                                  getImage(ImageSource.camera)),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.image),
                                          title: const Text('Gallery'),
                                          onTap: () => Navigator.of(context)
                                              .pop(getImage(
                                                  ImageSource.gallery)),
                                        )
                                      ],
                                    ),
                                  ));
                        },
                      ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                  child: Text('Truong Phuoc Tin',
                      style: AppTextStyle.homeTextStyle)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Stack(
                alignment: Alignment.centerRight,
                children: <Widget>[
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Search for post ...',
                      hoverColor: AppColors.mainColor,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mainColor,
                            )
                          ]),
                      child: IconButton(
                        icon: Icon(Icons.search, color: AppColors.whiteColor),
                        onPressed: () async {
                          Post? post = await postClient.getPostFetch(
                            id: searchController.text,
                          );

                          if (post != null) {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('ID: ${post.id.toString()}'),
                                        Text(
                                            'UserID: ${post.userId.toString()}'),
                                        Text('Title: ${post.title}'),
                                        Text('Body: ${post.body}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
              child: Text('Posts', style: AppTextStyle.homeTextStyle),
            ),
            const PostPageView()
          ],
        ),
      ),
    );
  }
}

class PostPageView extends StatefulWidget {
  const PostPageView({Key? key}) : super(key: key);

  @override
  State<PostPageView> createState() => _PostPageViewState();
}

class _PostPageViewState extends State<PostPageView> {
  PostClient postClient = PostClient();

  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
        future: postClient.getPost(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container(
              height: 700,
              width: double.infinity,
              child: ListView.builder(
                  // scrollDirection: Axis.horizontal,
                  controller: controller,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) =>
                      PostItem(snapshot.data![index])),
            );
          }
        });
  }
}

class PostItem extends StatelessWidget {
  final Post post;
  PostItem(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
          child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                  // width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('ID Post: ${post.id.toString()}'),
                        subtitle: Text(post.title.toString()),
                      ),
                      // Text(post.body),
                    ],
                  )))),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return InformationWidget(
            post: post,
          );
        }),
      ),
    );
  }
}
