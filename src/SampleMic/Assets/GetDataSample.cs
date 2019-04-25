using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GetDataSample : MonoBehaviour
{
    public AudioClip clip;
    public int lengthYouWant;

    void Start()
    {
        var data = new float[lengthYouWant];
        clip.GetData(data, 0);
    }
}