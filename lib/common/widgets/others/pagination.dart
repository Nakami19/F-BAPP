import 'package:f_bapp/common/providers/pagination_provider.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class Pagination extends StatefulWidget {
//    Pagination({
//     super.key,
//     required this.scrollController
//     });

//   ScrollController scrollController;

//   @override
//   State<Pagination> createState() => _PaginationState();
// }

// class _PaginationState extends State<Pagination> {

//     void _resetScroll() {
//     widget.scrollController.animateTo(
//       0.0,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     final provider = context.read<PaginationProvider>();
//     print(provider.getNumPages());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<PaginationProvider>();
//     final merchantProvider = context.read<MerchantProvider>();
//     return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 TextButton(
//                   onPressed: provider.page > 0 ? () {
//                    provider.previousPage();
//                    _resetScroll(); 
//                   }  : null,
//                   child: Row(
//                     children: [
//                       Icon(Icons.arrow_back_ios, size: 16),
//                       // Text('Anterior'),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   'Página ${provider.page + 1} de ${provider.getNumPages()+1}',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 TextButton(
//                   onPressed: provider.page + 1 < provider.getNumPages()
//                       ? () {
//                         merchantProvider.Listorders(limit: 5, page: provider.getNumPages());
//                         provider.nextPage();
//                         _resetScroll();
//                         }
//                       : null,
//                   child: Row(
//                     children: [
//                       // Text('Siguiente'),
//                       Icon(Icons.arrow_forward_ios, size: 16),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
// }

class Pagination extends StatelessWidget {
  final ScrollController scrollController;

  Pagination({required this.scrollController});

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
                    _resetScroll();
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
                    _resetScroll();
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

  void _resetScroll() {
    scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}