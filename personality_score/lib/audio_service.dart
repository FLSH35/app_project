import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance

  Future<void> playBeat() async {
    try {
      await _audioPlayer.play(AssetSource('assets/beat_sound.mp3')); // Play the beep sound
    } catch (e) {
      print("Error playing beat: $e");
    }
  }

  void dispose() {
    _audioPlayer.dispose(); // Dispose the audio player when no longer needed
  }
}
