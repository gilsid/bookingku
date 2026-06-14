/// Date Picker Horizontal widget matching Figma designs.
///
/// Menyediakan horizontal scroll tanggal dengan header Bulan & Tahun serta navigasi (< >).
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_radius.dart';

class DatePickerHorizontal extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DatePickerHorizontal({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DatePickerHorizontal> createState() => _DatePickerHorizontalState();
}

class _DatePickerHorizontalState extends State<DatePickerHorizontal> {
  late DateTime _focusedMonth;
  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _focusedMonth = widget.selectedDate;
    _generateDates();
  }

  void _generateDates() {
    // Menghasilkan 14 hari dimulai dari tanggal saat ini
    final today = DateTime.now();
    _dates = List.generate(14, (index) {
      return DateTime(today.year, today.month, today.day + index);
    });
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + offset, 1);
      // Pindahkan pilihan ke tanggal 1 bulan baru jika beda bulan
      if (_focusedMonth.month != widget.selectedDate.month) {
        final newDate = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
        widget.onDateSelected(newDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Format nama Bulan & Tahun Indonesia
    final monthYearStr = DateFormat('MMMM yyyy', 'id_ID').format(_focusedMonth);

    return Column(
      children: [
        // Month/Year navigation bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              monthYearStr,
              style: AppTextStyles.headingSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
                  onPressed: () => _changeMonth(-1),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Dates horizontal scroll
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _dates.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final date = _dates[index];
              final isSelected = date.year == widget.selectedDate.year &&
                  date.month == widget.selectedDate.month &&
                  date.day == widget.selectedDate.day;

              // Format Hari singkat (SEN, SEL, RAB, dsb)
              final dayName = DateFormat('E', 'id_ID').format(date).toUpperCase().substring(0, 3);
              final dayNum = DateFormat('dd').format(date);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _focusedMonth = date;
                  });
                  widget.onDateSelected(date);
                },
                child: Container(
                  width: 62,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryDark : AppColors.white,
                    borderRadius: AppRadius.borderRadiusL,
                    border: Border.all(
                      color: isSelected ? AppColors.primaryDark : AppColors.borderGrey,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white70 : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dayNum,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
