import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

class CustomAppointmentPicker extends StatefulWidget {
  final DateTime? initialDate;

  const CustomAppointmentPicker({super.key, this.initialDate});

  static Future<DateTime?> show(BuildContext context, {DateTime? initialDate}) {
    return showModalBottomSheet<DateTime?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomAppointmentPicker(initialDate: initialDate),
    );
  }

  @override
  State<CustomAppointmentPicker> createState() => _CustomAppointmentPickerState();
}

class _CustomAppointmentPickerState extends State<CustomAppointmentPicker> {
  late DateTime _displayedMonth;
  DateTime? _selectedDate;
  bool _showTimeSelection = false;

  final List<String> _weekDays = ['Dim.', 'Lun.', 'Mar.', 'Mer.', 'Jeu.', 'Ven.', 'Sam.'];
  final List<String> _timeSlots = ['09:00', '09:45', '10:30', '11:15', '12:00', '12:45'];
  
  static const List<String> _monthsFr = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
  ];

  static const List<String> _fullWeekDays = [
    'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'
  ];

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDate ?? DateTime.now();
    _displayedMonth = DateTime(initial.year, initial.month, 1);
    
    // Si on a déjà une date avec heure (ex: lors d'une modification), on présélectionne la date
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
      // Optionnel: on pourrait aller directement à l'étape du temps si une heure était déjà choisie
    }
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  void _onDateSelected(DateTime date) {
    if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
      return; // Ne pas permettre de sélectionner une date passée
    }
    setState(() {
      _selectedDate = date;
      _showTimeSelection = true;
    });
  }

  void _onTimeSelected(String timeStr) {
    if (_selectedDate == null) return;
    
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    final finalDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      hour,
      minute,
    );
    
    Navigator.of(context).pop(finalDateTime);
  }

  String _getFormattedDateHeader() {
    if (_selectedDate == null) return '';
    // weekday va de 1 (Lundi) à 7 (Dimanche)
    final dayName = _fullWeekDays[_selectedDate!.weekday - 1];
    final monthName = _monthsFr[_selectedDate!.month - 1];
    return '$dayName, ${_selectedDate!.day} $monthName';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        top: 24.h,
        left: 20.w,
        right: 20.w,
        bottom: MediaQuery.of(context).padding.bottom + 20.h,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showTimeSelection ? _buildTimeSelectionView() : _buildDateSelectionView(),
      ),
    );
  }

  Widget _buildDateSelectionView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Choisissez un jour',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 28.sp),
              onPressed: _previousMonth,
            ),
            Text(
              '${_monthsFr[_displayedMonth.month - 1]} ${_displayedMonth.year}',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: AppColors.textPrimary, size: 28.sp),
              onPressed: _nextMonth,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // En-tête des jours
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _weekDays.map((day) => SizedBox(
            width: 32.w,
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          )).toList(),
        ),
        SizedBox(height: 12.h),
        // Grille des jours
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final int daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    // weekday: 1=Lundi, 7=Dimanche. Dans notre tableau (Dim=0), on ajuste:
    final int firstDayWeekday = DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday;
    final int firstDayOffset = firstDayWeekday == 7 ? 0 : firstDayWeekday;

    final int totalCells = daysInMonth + firstDayOffset;
    final int rows = (totalCells / 7).ceil();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Column(
      children: List.generate(rows, (rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (colIndex) {
              final cellIndex = rowIndex * 7 + colIndex;
              final day = cellIndex - firstDayOffset + 1;

              if (day < 1 || day > daysInMonth) {
                return SizedBox(width: 36.w, height: 36.w);
              }

              final currentDate = DateTime(_displayedMonth.year, _displayedMonth.month, day);
              final isPast = currentDate.isBefore(today);
              final isSelected = _selectedDate != null &&
                  _selectedDate!.year == currentDate.year &&
                  _selectedDate!.month == currentDate.month &&
                  _selectedDate!.day == currentDate.day;

              Color textColor;
              Color bgColor = Colors.transparent;

              if (isSelected) {
                bgColor = AppColors.accentGreenLight;
                textColor = AppColors.white;
              } else if (isPast) {
                textColor = AppColors.grey400;
                bgColor = AppColors.grey100.withValues(alpha: 0.5);
              } else {
                textColor = AppColors.accentGreenLight;
                bgColor = AppColors.accentGreenLight.withValues(alpha: 0.1);
              }

              return GestureDetector(
                onTap: isPast ? null : () => _onDateSelected(currentDate),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildTimeSelectionView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.sp),
              onPressed: () {
                setState(() => _showTimeSelection = false);
              },
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            Expanded(
              child: Center(
                child: Text(
                  _getFormattedDateHeader(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            SizedBox(width: 40.w), // Pour balancer le bouton back
          ],
        ),
        SizedBox(height: 16.h),
        Center(
          child: Text(
            'Durée: 45 min',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        ..._timeSlots.map((time) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: InkWell(
              onTap: () => _onTimeSelected(time),
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.accentGreenLight, width: 1.5),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentGreenLight,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
