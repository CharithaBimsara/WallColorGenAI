import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import '../../state/room_cubit.dart';
import '../../../widgets/custom_sliver_app_bar_delegate.dart';
import '../../../widgets/responsive_button.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  RoomPageState createState() => RoomPageState();
}

class RoomPageState extends State<RoomPage> {
  String name = "Charitha Adikari";
  String email = "defaultEmail@example.com";

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _uploadButtonKey = GlobalKey();

  String _complexity = 'all';
  String _texture = 'all';
  Color? _selectedColor;

  final Map<Color?, String> _colorSet = {
    null: 'all', // All
    const Color.fromARGB(255, 255, 0, 0): 'red', // Red
    const Color.fromARGB(255, 0, 255, 0): 'green', // Green
    const Color.fromARGB(255, 0, 0, 255): 'blue', // Blue
    const Color.fromARGB(255, 255, 255, 0): 'yellow', // Yellow
    const Color.fromARGB(255, 255, 192, 203): 'pink', // Pink
    const Color.fromARGB(255, 128, 0, 128): 'purple', // Purple
    const Color.fromARGB(255, 255, 0, 255): 'magenta', // Magenta
    const Color.fromARGB(255, 128, 128, 128): 'grey', // Grey
    const Color.fromARGB(255, 255, 255, 255): 'white', // White
    const Color.fromARGB(255, 0, 0, 0): 'black', // Black
    const Color.fromARGB(255, 165, 42, 42): 'brown', // Brown
    const Color.fromARGB(255, 255, 165, 0): 'orange', // Orange
    const Color.fromARGB(255, 64, 224, 208): 'turquoise', // Turquoise
    const Color.fromARGB(255, 0, 128, 128): 'teal', // Teal
    const Color.fromARGB(255, 230, 230, 250): 'lavender', // Lavender
    const Color.fromARGB(255, 0, 0, 128): 'navy', // Navy
    const Color.fromARGB(255, 245, 245, 220): 'beige', // Beige
    const Color.fromARGB(255, 255, 127, 80): 'coral', // Coral
    const Color.fromARGB(255, 62, 180, 137): 'mint', // Mint
    const Color.fromARGB(255, 225, 229, 180): 'peach', // Peach
    const Color.fromARGB(255, 255, 215, 0): 'gold', // Gold
    const Color.fromARGB(255, 192, 192, 192): 'silver', // Silver
  };

  final List<Map<String, dynamic>> hardcodedImages = [
  {
    'url': 'https://feedbackimages3.s3.amazonaws.com/yello_com_high_no_text.jpg',
    'complexity': 'High',
    'texture': 'No',
    'color': 'Yellow',
  },
  {
    'url': 'https://feedbackimages3.s3.amazonaws.com/what-colors-go-with-mint-green.jpg',
    'complexity': 'High',
    'texture': 'Yes',
    'color': 'Mint',
  },
  {
    'url': 'https://feedbackimages3.s3.amazonaws.com/large_319A_MG_DesignPantone_03.jpg',
    'complexity': 'Low',
    'texture': 'Yes',
    'color': 'Coral',
  },
  {
    'url': 'https://feedbackimages3.s3.amazonaws.com/com_high_tex_yes_colo_grey38.jpg',
    'complexity': 'High',
    'texture': 'Yes',
    'color': 'Grey',
  },
  {
    'url': 'https://feedbackimages3.s3.amazonaws.com/com_high_tex_no_colo_green1.jpg',
    'complexity': 'High',
    'texture': 'No',
    'color': 'Green',
  },
  {
    'url': 'https://feedbackimages3.s3.amazonaws.com/brown_colour_combinations.jpg',
    'complexity': 'Low',
    'texture': 'No',
    'color': 'Brown',
  },
  {
    'url': 'https://feedbackimages3.s3.amazonaws.com/4270f16c29f68bd266e204ed8ca37fbe.jpg',
    'complexity': 'Low',
    'texture': 'Yes',
    'color': 'Silver',
  },
  {
    'url': 'https://feedbackimages3.s3.amazonaws.com/1a2ca4888171e42c404447a038e72cc1.jpg',
    'complexity': 'Low',
    'texture': 'No',
    'color': 'Teal',
  },
  {
    'url': 'https://feedbackimages3.s3.amazonaws.com/0cac43df1bfef60114e96c589e007ab7.jpg',
    'complexity': 'Low',
    'texture': 'Yes',
    'color': 'Red',
  },
];

  List<Map<String, dynamic>> _getFilteredImages() {
    return hardcodedImages.where((image) {
      bool matchesComplexity = _complexity.toLowerCase() == 'all' ||
          image['complexity'].toString().toLowerCase() ==
              _complexity.toLowerCase();

      bool matchesTexture = _texture.toLowerCase() == 'all' ||
          image['texture'].toString().toLowerCase() == _texture.toLowerCase();

      bool matchesColor = _selectedColor == null ||
          image['color'].toString().toLowerCase() ==
              _colorSet[_selectedColor]!.toLowerCase();

      return matchesComplexity && matchesTexture && matchesColor;
    }).toList();
  }

  void _applyFilters() {
    // Convert selected color to the format expected by the API
    String colorParam = _selectedColor != null
        ? _colorSet[_selectedColor]!.toLowerCase()
        : 'all';

    // Update state to trigger rebuild with new filters
    setState(() {});

    // Fetch new data from API with current filters
    BlocProvider.of<RoomCubit>(context).fetchImages(
        _complexity.toLowerCase(), _texture.toLowerCase(), colorParam);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkButtonVisibility();
    });
    _fetchImages();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _checkButtonVisibility();
  }

  void _checkButtonVisibility() {
    final renderBox =
        _uploadButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero).dy;
      final screenHeight = MediaQuery.of(context).size.height;

      if (position < screenHeight && position > 0) {
        BlocProvider.of<RoomCubit>(context).showFloatingButton(false);
      } else {
        BlocProvider.of<RoomCubit>(context).showFloatingButton(true);
      }
    }
  }

  void _fetchImages() {
    String colorParam = _selectedColor != null
        ? '#${_selectedColor!.value.toRadixString(16).substring(2)}'
        : 'all';
    // String colorParam =
    //     _selectedColor != null ? _colorSet[_selectedColor]! : 'all';

    BlocProvider.of<RoomCubit>(context)
        .fetchImages(_complexity, _texture, colorParam);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // If args is not null, update name and email
    if (args != null) {
      name = args['name'] ?? "Charitha Adikari";
      email = args['email'] ?? "defaultEmail@example.com";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              delegate: CustomSliverAppBarDelegate(
                expandedHeight: 100,
              ),
              pinned: true,
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                padding: const EdgeInsets.all(5.0),
                key: _uploadButtonKey,
                child: ResponsiveButton(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/objectmarking',
                      arguments: {
                        'name': name,
                        'email': email,
                      },
                    );
                  },
                  height: 100,
                  iconColor: Colors.white,
                  icon: const Icon(
                    Icons.add_a_photo,
                    size: 60,
                    color: Colors.white,
                  ),
                  text: "Capture your room",
                  textColor: Colors.white,
                  textSize: 30,
                  width: 120,
                ),
              ),
            ),
            SliverPadding(
  padding: const EdgeInsets.all(8.0),
  sliver: SliverToBoxAdapter(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Discover Matching Style',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 30),

        // Filters with Border
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // Border color
              width: 1.0,         // Border width
            ),
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          padding: const EdgeInsets.all(12.0), // Padding inside the border
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Complexity Column
              Column(
                children: [
                  const Text(
                    "Complexity",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: _complexity,
                    items: const [
                      DropdownMenuItem(value: 'low', child: Text('Low')),
                      DropdownMenuItem(value: 'high', child: Text('High')),
                      DropdownMenuItem(value: 'all', child: Text('All')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _complexity = value!;
                        _applyFilters();
                      });
                    },
                  ),
                ],
              ),

              // Texture Column
              Column(
                children: [
                  const Text(
                    "Texture",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: _texture,
                    items: const [
                      DropdownMenuItem(value: 'yes', child: Text('Yes')),
                      DropdownMenuItem(value: 'no', child: Text('No')),
                      DropdownMenuItem(value: 'all', child: Text('All')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _texture = value!;
                        _applyFilters();
                      });
                    },
                  ),
                ],
              ),

              // Color Column
              Column(
                children: [
                  const Text(
                    "Color",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Select Color'),
                            content: SingleChildScrollView(
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: _colorSet.keys.map((color) {
                                  final bool isSelected =
                                      _selectedColor == color;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedColor =
                                            isSelected ? null : color;
                                        Navigator.of(context).pop();
                                        _applyFilters();
                                      });
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: color ?? Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.transparent,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Icon(Icons.color_lens),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),

            BlocBuilder<RoomCubit, RoomState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return SliverToBoxAdapter(child: _buildShimmerPlaceholders());
                } else if (state.hasError) {
                  // Display filtered hardcoded images in case of error
                  List<Map<String, dynamic>> filteredImages =
                      _getFilteredImages();
                  return _buildImageGrid(filteredImages);
                  //   return SliverStaggeredGrid.countBuilder(
                  //     crossAxisCount: 4,
                  //     itemCount: filteredImages.length,
                  //     itemBuilder: (context, index) {
                  //       return GestureDetector(
                  //         onTap: () {
                  //           showDialog(
                  //             context: context,
                  //             builder: (context) => EnlargedImageDialog(
                  //               imageUrl: filteredImages[index]['url'],
                  //             ),
                  //           );
                  //         },
                  //         child: Card(
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           child: ClipRRect(
                  //             borderRadius: BorderRadius.circular(10),
                  //             child: Image.network(
                  //               filteredImages[index]['url'],
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     staggeredTileBuilder: (int index) => const StaggeredTile.fit(2),
                  //     mainAxisSpacing: 5.0,
                  //     crossAxisSpacing: 5.0,
                  //   );
                  // }
                } else {
                  // Display API-loaded images
                  //   return SliverStaggeredGrid.countBuilder(
                  //     crossAxisCount: 4,
                  //     itemCount: state.images.length,
                  //     itemBuilder: (context, index) {
                  //       return GestureDetector(
                  //         onTap: () {
                  //           showDialog(
                  //             context: context,
                  //             builder: (context) => EnlargedImageDialog(
                  //               imageUrl: state.images[index].augmentedImageUrl,
                  //             ),
                  //           );
                  //         },
                  //         child: Card(
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           child: ClipRRect(
                  //             borderRadius: BorderRadius.circular(10),
                  //             child: Image.network(
                  //               state.images[index].augmentedImageUrl,
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     staggeredTileBuilder: (int index) => const StaggeredTile.fit(2),
                  //     mainAxisSpacing: 5.0,
                  //     crossAxisSpacing: 5.0,
                  //   );
                  // }
                  return _buildApiImageGrid(state.images);
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<RoomCubit, RoomState>(
        builder: (context, state) {
          return Visibility(
            visible: state.showFloatingButton,
            child: Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: Colors.red,
                onPressed: () {},
                child: const Icon(
                  size: 30,
                  Icons.add_a_photo,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageGrid(List<Map<String, dynamic>> images) {
    return SliverStaggeredGrid.countBuilder(
      crossAxisCount: 4,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => EnlargedImageDialog(
                imageUrl: images[index]['url'],
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                images[index]['url'],
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
      staggeredTileBuilder: (int index) => const StaggeredTile.fit(2),
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
    );
  }

  Widget _buildApiImageGrid(List<dynamic> images) {
    return SliverStaggeredGrid.countBuilder(
      crossAxisCount: 4,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => EnlargedImageDialog(
                imageUrl: images[index].augmentedImageUrl,
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                images[index].augmentedImageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
      staggeredTileBuilder: (int index) => const StaggeredTile.fit(2),
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
    );
  }
}

Widget _buildShimmerPlaceholders() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: GridView.builder(
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.white,
        );
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    ),
  );
}

class EnlargedImageDialog extends StatelessWidget {
  final String imageUrl;

  EnlargedImageDialog({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(imageUrl),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
