import 'package:f_bapp/common/providers/pagination_provider.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Pagination extends StatelessWidget {
  // final ScrollController scrollController;
  // final Future<List<dynamic>> Function(int limit, int page, Map<String, dynamic> filters) fetchData;

  const Pagination({
    super.key, 
    // required this.scrollController
    // required this.fetchData,
    });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaginationProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: provider.page > 0
                ? () async {
                    await provider.previousPage(context);
                    // _resetScroll();
                  }
                : null,
            child: Row(
              children: [Icon(Icons.arrow_back_ios, size: 16)],
            ),
          ),
          Text(
            'Página ${provider.page + 1} de ${provider.getNumPages()}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: provider.page + 1 < provider.getNumPages()
                ? () async {
                    await provider.nextPage(context);
                    // _resetScroll();
                  }
                : null,
            child: Row(
              children: [Icon(Icons.arrow_forward_ios, size: 16)],
            ),
          ),
        ],
      ),
    );
  }
}