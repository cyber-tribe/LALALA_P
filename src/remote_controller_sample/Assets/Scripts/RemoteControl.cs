using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Text;
using System;
using WiimoteApi;

public class RemoteControl : MonoBehaviour {
    private Wiimote wiimote;
    private GameObject cube;
    private Vector3 cp;

    // Use this for initialization
    void Start () {
		WiimoteManager.FindWiimotes();
    }
	
	// Update is called once per frame
	void Update () {
		if (!WiimoteManager.HasWiimote()) { return; }

        wiimote = WiimoteManager.Wiimotes[0];

        cube = GameObject.Find("Cube");
        cp = cube.transform.position;

        int ret;
        do
        {
            ret = wiimote.ReadWiimoteData();
        } while (ret > 0);
		float[] pointer = wiimote.Ir.GetPointingPosition();
        cube.transform.position = new Vector3((pointer[0]-0.5f)*16f, (pointer[1]-0.5f)*3f, cube.transform.position.z);
    }
}
