using UnityEngine;
using System.Collections;

[
    RequireComponent(typeof(AudioSource))
    ]
public class MicrophoneSource : MonoBehaviour
{
    private void Start()
    {
        var audio = GetComponent<AudioSource>();
        audio.clip = Microphone.Start(null, false, 10, 44100);
        while (Microphone.GetPosition(null) <= 0) { }
        audio.Play();
    }
}