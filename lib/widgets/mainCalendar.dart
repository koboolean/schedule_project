import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatefulWidget {
  const MainCalendar({Key? key, required DateTime selectedDate}) : super(key: key);

  @override
  State<MainCalendar> createState() => _MainCalendarState();
}

class _MainCalendarState extends State<MainCalendar> {
  //late final ValueNotifier<List<Event>> _selectedEvents;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay; //Future 타입, 지금은 없지만 미래에 요청한 데이터 혹은 에러가 담길 그릇

  /*@override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    //seledtedDay가 변경이 되면 seletedEvents가 실행된다
    //ValueNotifier :value 가 변경되면 해당 함수를 실행
  }

  @override
  void dispose(){
    _selectedEvents.dispose();
    super.dispose();
    //위젯 트리에서 state object가 영구적으로 제거될 때 호출된다.
    //컨트롤러 객체가 제거 될 때 변수에 할당 된 메모리를 해제하기 위해
  }

  List<Event> _getEventsForDay(DateTime day){
    // Implementation example
    return kEvents[day] ?? [];
  }
*/

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay){
    if(!isSameDay(_selectedDay, selectedDay)){
      //선택된 날짜의 상태를 갱신합니다.
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return TableCalendar(
      locale: 'ko_KR',  //달력 언어 설정
      daysOfWeekHeight: 30.0, //요일 높이 설정
      firstDay: DateTime.utc(1995, 01, 01), //최소날짜
      lastDay: DateTime.utc(2095, 12, 31),  //최대날짜
      focusedDay: _focusedDay,  //달력을 보여줄 기준 날짜
      //HeaderStyle
      headerStyle: HeaderStyle(
          titleCentered: true, //title 중앙 정렬 여부
          titleTextFormatter: (date, locale) =>   //title 날짜 형태
          DateFormat.yMMMM(locale).format(date),
          titleTextStyle: const TextStyle(  //title Style 지정
            fontSize: 20.0,
            color: Colors.deepOrange,
          ),
          formatButtonVisible: false,  //formatButton 노출 여부
          //header Padding 조절, vertical : 수직, horizontal : 수평
          headerPadding: const EdgeInsets.symmetric(vertical : 4.0, horizontal: 1.0),
          //leftChevron Icon 정의
          leftChevronIcon: const Icon(
            Icons.arrow_left,
            size: 40.0,
          ),
          //rightChevron Icon 정의
          rightChevronIcon: const Icon(
            Icons.arrow_right,
            size: 40.0,
          ),
      ),
      calendarBuilders: CalendarBuilders(
        //header 영역에 대한 textStyle 지정
          dowBuilder: (context, date){
            final day = DateFormat('E', 'ko').format(date);
            if(day == "토"){
              return Center(
                child: Text(
                  day,
                  style: TextStyle(color: Colors.blue),
                ),
              );
            }else if(day == "일"){
              return Center(
                child: Text(
                  day,
                  style: TextStyle(color: Colors.red),
                ),
              );
            }else{
              return Center(
                child: Text(
                  day,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }
          },
          //body 영역에 대한 textStyle 지정
          defaultBuilder: (context, date, _){
            final day = DateFormat('E', 'ko').format(date);
            if(day == "토"){
              return Center(
                child: Text(
                  date.day.toString(),
                  style: TextStyle(color: Colors.blue),
                ),
              );
            }else if(day == "일"){
              return Center(
                child: Text(
                  date.day.toString(),
                  style: TextStyle(color: Colors.red),
                ),
              );
            }else{
              return Center(
                child: Text(
                  date.day.toString(),
                  style: TextStyle(color: Colors.black),
                ),
              );
            }
          }
      ),

      calendarStyle: CalendarStyle(
        cellMargin: const EdgeInsets.only(left: 10.0, right: 10.0),
        cellPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
        //캘린더 전체를 선으로 구분
        tableBorder: TableBorder.all(color: Colors.black12),

        /*
        weekendTextStyle: TextStyle(
          color: DateFormat.E().toString() == "Sun" ? Colors.red : Colors.blue,
        ),

        holidayTextStyle: TextStyle(
          color: Colors.red,
        ),

        (주말 제외)주간 날짜의 박스 스타일을 설정
        defaultDecoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.fromBorderSide(BorderSide()),
        ),
        주말의 박스 스타일을 설정
        weekendDecoration: BoxDecoration(
          color: Colors.blue,
          border: Border.fromBorderSide(BorderSide()),
        ),
         */
      ),

      onDaySelected: _onDaySelected,
      selectedDayPredicate: (DateTime day){
        //selectedDay와 동일한 날짜의 모양을 바꿔줍니다.
        //클릭한 날짜에 동그라미 표시가 되도록
        return isSameDay(_selectedDay, day);
      },
    );
  }
}
