import 'package:flutter/material.dart';
import 'package:demo_dio_imagepicker/constants/constants.dart';
import 'package:demo_dio_imagepicker/model/model.dart';
import 'package:demo_dio_imagepicker/client/post_client.dart';

class InformationWidget extends StatefulWidget {
  final Post post;
  const InformationWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<InformationWidget> createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<InformationWidget> {
  PostClient postClient = PostClient();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15)),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded,
                            color: AppColors.blackColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15)),
                      child: IconButton(
                        icon: Icon(Icons.search, color: AppColors.blackColor),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        children: [
                          const Text('ID: ', style: AppTextStyle.homeTextStyle),
                          Text(widget.post.id.toString(),
                              style: AppTextStyle.homeTextStyle),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(widget.post.title,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text('Body: ',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(widget.post.body,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 25, bottom: 5),
                      child:
                          Text('Update: ', style: AppTextStyle.homeTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'Title',
                          hoverColor: AppColors.mainColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: TextField(
                        controller: bodyController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'Body',
                          hoverColor: AppColors.mainColor,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (titleController.text != '' &&
                            bodyController.text != '') {
                          PostInfo postInfo = PostInfo(
                            title: titleController.text,
                            body: bodyController.text,
                          );

                          PostInfo? retrievedPost = await postClient.updatePost(
                            postInfo: postInfo,
                            id: widget.post.id.toString(),
                          );

                          if (retrievedPost != null) {
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
                                        Text('Title: ${retrievedPost.title}'),
                                        Text('Body: ${retrievedPost.body}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text('Lỗi')),
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Update post',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 30,
                width: double.infinity,
                child: IconButton(
                  icon: Icon(Icons.delete, color: AppColors.whiteColor),
                  onPressed: () async {
                    await postClient.deletePost(id: widget.post.id.toString());
                    final snackBar = SnackBar(
                      content: Text(
                        'Post at id ${widget.post.id} deleted!',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              ),
            )));
  }
}
