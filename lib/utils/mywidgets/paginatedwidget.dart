import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagination/flutter_pagination.dart';
import 'package:flutter_pagination/widgets/button_styles.dart';

class PaginatedWidget extends StatefulWidget {
  const PaginatedWidget({
    super.key,
    required this.itemBuilder,
    required this.infoText,
    required this.itemCount,
    required this.itemsPerPage,
    this.onRefresh = noRefresh,
    this.enableSearch = false,
    this.onChangedSearch,
  });

  final Function(BuildContext context, int i) itemBuilder;
  final String infoText;
  final int itemsPerPage;
  final int itemCount;
  final bool enableSearch;
  final Future<void> Function() onRefresh;
  final void Function(String value)? onChangedSearch;
  static Future<void> noRefresh() async {}

  @override
  State<PaginatedWidget> createState() => _PaginatedWidgetState();
}

class _PaginatedWidgetState extends State<PaginatedWidget> {
  int numpages = 1;
  int actualpage = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0) {
      numpages = 1;
    } else {
      numpages = (widget.itemCount / widget.itemsPerPage).ceil();
    }

    if (actualpage > numpages) {
      actualpage = numpages;
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.onRefresh,
            child: ListView(
              children: List.generate(
                actualpage == numpages
                    ? (widget.itemCount - (numpages - 1) * widget.itemsPerPage)
                    : widget.itemsPerPage,
                (i) => widget.itemBuilder(
                  context,
                  i + (actualpage - 1) * widget.itemsPerPage,
                ),
              ),
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.infoText,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                  visible: widget.enableSearch,
                  child: SizedBox(
                    width: 240,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Buscar'),
                        isDense: true,
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        if (widget.onChangedSearch != null) {
                          widget.onChangedSearch!(value);
                          if (actualpage != 1) {
                            setState(() {
                              actualpage = 1;
                            });
                          }
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Spacer(),
                Pagination(
                  prevButtonStyles: PaginateSkipButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.grey,
                    ),
                    buttonBackgroundColor: Colors.white,
                  ),
                  nextButtonStyles: PaginateSkipButton(
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.grey,
                    ),
                    buttonBackgroundColor: Colors.white,
                  ),
                  paginateButtonStyles: PaginateButtonStyles(
                    backgroundColor: Colors.grey,
                    activeBackgroundColor: MC_darkblue,
                    paginateButtonBorderRadius: BorderRadius.circular(10.0),
                  ),
                  onPageChange: (number) {
                    onPageChange(number);
                  },
                  totalPage: numpages,
                  show: numpages < 4 ? numpages - 1 : 3,
                  currentPage: actualpage,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void onPageChange(int number) {
    setState(() {
      actualpage = number;
    });
  }
}
