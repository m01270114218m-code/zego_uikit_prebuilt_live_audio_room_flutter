import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

const int zegoAppId = int.fromEnvironment('ZEGO_APP_ID', defaultValue: 0);
const String zegoAppSign = String.fromEnvironment('ZEGO_APP_SIGN', defaultValue: '');

void main() { WidgetsFlutterBinding.ensureInitialized(); runApp(const VoiceRoomsApp()); }

class VoiceRoomsApp extends StatelessWidget {
  const VoiceRoomsApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false, title: 'Voice Rooms',
    theme: ThemeData(brightness: Brightness.dark, scaffoldBackgroundColor: const Color(0xFF0B0B12),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B5CF6), brightness: Brightness.dark), useMaterial3: true),
    home: const HomePage());
}

class HomePage extends StatefulWidget { const HomePage({super.key}); @override State<HomePage> createState()=>_HomePageState(); }
class _HomePageState extends State<HomePage> {
  final name=TextEditingController(), room=TextEditingController();
  @override void initState(){super.initState(); name.text='Guest'; room.text='room_001';}
  @override void dispose(){name.dispose(); room.dispose(); super.dispose();}
  void enter(bool host){
    if(zegoAppId==0 || zegoAppSign.isEmpty){showDialog(context:context,builder:(_)=>AlertDialog(
      title:const Text('إعداد ZEGOCLOUD'),content:const Text('شغّل التطبيق باستخدام ZEGO_APP_ID و ZEGO_APP_SIGN عبر --dart-define قبل الدخول للغرفة.'),
      actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('حسنًا'))]));return;}
    final uid=name.text.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_]'),'_');
    final rid=room.text.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_]'),'_');
    if(uid.isEmpty||rid.isEmpty)return;
    Navigator.push(context,MaterialPageRoute(builder:(_)=>RoomPage(userId:uid,userName:name.text.trim(),roomId:rid,host:host)));
  }
  @override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:ListView(padding:const EdgeInsets.fromLTRB(22,28,22,28),children:[
    const Icon(Icons.graphic_eq_rounded,size:58,color:Color(0xFF9B6DFF)),const SizedBox(height:14),
    const Text('Voice Rooms',textAlign:TextAlign.center,style:TextStyle(fontSize:32,fontWeight:FontWeight.w800)),
    const SizedBox(height:7),Text('غرف صوتية مباشرة • دردشة • متحدثين • إدارة المقاعد',textAlign:TextAlign.center,style:TextStyle(color:Colors.white54)),
    const SizedBox(height:34),field(name,'اسمك',Icons.person_outline),const SizedBox(height:14),field(room,'معرّف الغرفة',Icons.meeting_room_outlined),
    const SizedBox(height:24),FilledButton.icon(onPressed:()=>enter(true),icon:const Icon(Icons.mic_rounded),label:const Text('إنشاء غرفة'),
      style:FilledButton.styleFrom(minimumSize:const Size.fromHeight(56),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(18)))),
    const SizedBox(height:12),OutlinedButton.icon(onPressed:()=>enter(false),icon:const Icon(Icons.login_rounded),label:const Text('دخول إلى غرفة'),
      style:OutlinedButton.styleFrom(minimumSize:const Size.fromHeight(56),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(18)))),
    const SizedBox(height:30),const Feature(icon:Icons.people_alt_outlined,title:'غرف جماعية',text:'استضافة متحدثين وإدارة المقاعد.'),
    const Feature(icon:Icons.chat_bubble_outline,title:'تفاعل مباشر',text:'دردشة نصية داخل الغرفة.'),
    const Feature(icon:Icons.tune_rounded,title:'قابل للتخصيص',text:'الواجهة والميزات قابلة للتطوير حسب التطبيق النهائي.')
  ])));
  Widget field(TextEditingController c,String label,IconData icon)=>TextField(controller:c,decoration:InputDecoration(prefixIcon:Icon(icon),labelText:label,filled:true,fillColor:Colors.white.withOpacity(.055),border:OutlineInputBorder(borderRadius:BorderRadius.circular(18),borderSide:BorderSide.none)));
}
class RoomPage extends StatelessWidget {
  final String userId,userName,roomId; final bool host;
  const RoomPage({super.key,required this.userId,required this.userName,required this.roomId,required this.host});
  @override Widget build(BuildContext context)=>Scaffold(body:ZegoUIKitPrebuiltLiveAudioRoom(
    appID:zegoAppId,appSign:zegoAppSign,userID:userId,userName:userName,roomID:roomId,
    config:host?ZegoUIKitPrebuiltLiveAudioRoomConfig.host():ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()));
}
class Feature extends StatelessWidget {
  final IconData icon; final String title,text;
  const Feature({super.key,required this.icon,required this.title,required this.text});
  @override Widget build(BuildContext context)=>Card(margin:const EdgeInsets.only(bottom:10),color:Colors.white10,
    child:ListTile(leading:CircleAvatar(backgroundColor:const Color(0xFF8B5CF6),child:Icon(icon,color:Colors.white)),title:Text(title,style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text(text)));
}
