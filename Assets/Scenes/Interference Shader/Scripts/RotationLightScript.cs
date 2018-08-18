using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotationLightScript : MonoBehaviour {
    public float speed = 2f;
    public float maxAngle = 60f;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frames
	void Update () {
        transform.rotation = Quaternion.Euler( maxAngle*Mathf.Sin(Time.time*speed), 0f,  0f);
	}
}
