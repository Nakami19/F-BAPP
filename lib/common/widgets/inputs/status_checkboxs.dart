import 'package:f_bapp/config/theme/business_app_colors.dart';
import 'package:flutter/material.dart';

class StatusCheckboxs extends StatefulWidget {
  const StatusCheckboxs({super.key, required this.status, this.onTap, required this.selectedStatuses});

  final List<dynamic> status;
  final Function? onTap;
  final Set<String> selectedStatuses; 

  @override
  State<StatusCheckboxs> createState() => _StatusCheckboxsState();
}

class _StatusCheckboxsState extends State<StatusCheckboxs> {


  void filterStatus(String idStatus) {
    setState(() {
      if (widget.selectedStatuses.contains(idStatus)) {
        widget.selectedStatuses.remove(idStatus);
      } else {
        widget.selectedStatuses.add(idStatus);
      }

      if (widget.onTap != null) {
        widget.onTap!(widget.selectedStatuses);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Filtrar por estado",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.status.map((status) {
            final bool isSelected = widget.selectedStatuses.contains(status['idStatus']);
            return GestureDetector(
              onTap: () => {
                filterStatus(status['idStatus']),
              },
              child: AnimatedContainer(
                width: isSelected ? null : 35,
                height: isSelected ? null : 35,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? statusColors[status['name']]  : Colors.transparent,
                  border: Border.all(color: statusColors[status['name']] ?? Colors.transparent, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                child: Text(
                  isSelected
                      ? "${status['name']}"
                      : "",
                  style: const TextStyle(
                    color:  Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
